/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.game.SLTAssetState;
import saltr.game.SLTBoardLayer;
import saltr.game.SLTLevelParser;

/**
 * The SLT2DLevelParser class represents the 2D level parser.
 */
public class SLT2DLevelParser extends SLTLevelParser {

    private static var INSTANCE:SLT2DLevelParser;

    /**
     * Returns an instance of SLT2DLevelParser class.
     */
    public static function getInstance():SLT2DLevelParser {
        if (!INSTANCE) {
            INSTANCE = new SLT2DLevelParser(new Singleton());
        }
        return INSTANCE;
    }

    /**
     * Class constructor.
     */
    public function SLT2DLevelParser(singleton:Singleton) {
        if (singleton == null) {
            throw new Error("Class cannot be instantiated. Please use the method called getInstance.");
        }
    }

    /**
     * Parses the level content.
     * @param boardNodes - The board nodes.
     * @param assetMap - The asset map.
     */
    override public function parseLevelContent(boardNodes:Object, assetMap:Dictionary):Dictionary {
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardNode, assetMap);
        }
        return boards;
    }

    private function parseLevelBoard(boardNode:Object, assetMap:Dictionary):SLT2DBoard {
        var boardProperties:Object = {};
        if (boardNode.hasOwnProperty("properties")) {
            boardProperties = boardNode.properties;
        }

        var layers:Vector.<SLTBoardLayer> = new Vector.<SLTBoardLayer>();
        var layerNodes:Array = boardNode.layers;
        for (var i:int = 0, len:int = layerNodes.length; i < len; ++i) {
            var layerNode:Object = layerNodes[i];
            var layer:SLT2DBoardLayer = parseLayer(layerNode, i, assetMap);
            layers.push(layer);
        }

        var width:Number = boardNode.hasOwnProperty("width") ? boardNode.width : 0;
        var height:Number = boardNode.hasOwnProperty("height") ? boardNode.height : 0;

        return new SLT2DBoard(width, height, layers, boardProperties);
    }

    private function parseLayer(layerNode:Object, index:int, assetMap:Dictionary):SLT2DBoardLayer {
        //temporarily checking for 2 names until "layerId" is removed!
        var token:String = layerNode.hasOwnProperty("token") ? layerNode.token : layerNode.layerId;
        var layer:SLT2DBoardLayer = new SLT2DBoardLayer(token, index);
        parseAssetInstances(layer, layerNode.assets as Array, assetMap);
        return layer;
    }

    private function parseAssetInstances(layer:SLT2DBoardLayer, assetNodes:Array, assetMap:Dictionary):void {
        for (var i:int = 0, len:int = assetNodes.length; i < len; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var x:Number = assetInstanceNode.x;
            var y:Number = assetInstanceNode.y;
            var rotation:Number = assetInstanceNode.rotation;
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateIds:Array = assetInstanceNode.states as Array;
            layer.addAssetInstance(new SLT2DAssetInstance(asset.token, asset.getInstanceStates(stateIds), asset.properties, x, y, rotation));
        }
    }

    override protected function parseAssetState(stateNode:Object):SLTAssetState {
        var token:String = stateNode.hasOwnProperty("token") ? stateNode.token : null;
        var properties:Object = stateNode.hasOwnProperty("properties") ? stateNode.properties : null;
        var pivotX:Number = stateNode.hasOwnProperty("pivotX") ? stateNode.pivotX : 0;
        var pivotY:Number = stateNode.hasOwnProperty("pivotY") ? stateNode.pivotY : 0;

        return new SLT2DAssetState(token, properties, pivotX, pivotY);
    }
}
}

class Singleton {
}