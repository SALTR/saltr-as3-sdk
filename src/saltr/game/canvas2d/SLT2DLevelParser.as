/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.game.SLTAssetState;
import saltr.game.SLTCheckPointParser;
import saltr.game.SLTLevelParser;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLT2DLevelParser class represents the 2D level parser.
 * @private
 */
public class SLT2DLevelParser extends SLTLevelParser {
    private static var INSTANCE:SLT2DLevelParser;

    /**
     * Returns an instance of SLT2DLevelParser class.
     */
    saltr_internal static function getInstance():SLT2DLevelParser {
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
     * @param rootNodes The root node.
     * @param assetMap The asset map.
     * @return The parsed boards.
     */
    override saltr_internal function parseLevelContent(rootNode:Object, assetMap:Dictionary):Dictionary {
        var boardNodes:Object = getBoardsNode(rootNode);
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

        var layers:Vector.<SLT2DBoardLayer> = new Vector.<SLT2DBoardLayer>();
        var layerNodes:Array = boardNode.layers;
        for (var i:int = 0, len:int = layerNodes.length; i < len; ++i) {
            var layerNode:Object = layerNodes[i];
            var layer:SLT2DBoardLayer = parseLayer(layerNode, i, assetMap);
            layers.push(layer);
        }

        var width:Number = boardNode.hasOwnProperty("width") ? boardNode.width : 0;
        var height:Number = boardNode.hasOwnProperty("height") ? boardNode.height : 0;

        var config:SLT2DBoardConfig = new SLT2DBoardConfig(layers, boardNode, assetMap);
        return new SLT2DBoard(config, boardProperties, SLTCheckPointParser.parseCheckpoints(boardNode));
    }

    private function parseLayer(layerNode:Object, index:int, assetMap:Dictionary):SLT2DBoardLayer {
        //temporarily checking for 2 names until "layerId" is removed!
        var token:String = layerNode.hasOwnProperty("token") ? layerNode.token : layerNode.layerId;
        var layer:SLT2DBoardLayer = new SLT2DBoardLayer(token, index, layerNode.assets);
        return layer;
    }

    override protected function parseAssetState(stateNode:Object):SLTAssetState {
        var token:String = stateNode.hasOwnProperty("token") ? stateNode.token : null;
        var properties:Object = stateNode.hasOwnProperty("properties") ? stateNode.properties : null;
        var pivotX:Number = stateNode.hasOwnProperty("pivotX") ? stateNode.pivotX : 0;
        var pivotY:Number = stateNode.hasOwnProperty("pivotY") ? stateNode.pivotY : 0;
        var width:Number = stateNode.hasOwnProperty("width") ? stateNode.width : 0;
        var height:Number = stateNode.hasOwnProperty("height") ? stateNode.height : 0;

        return new SLT2DAssetState(token, properties, pivotX, pivotY, width, height);
    }
}
}

class Singleton {
}