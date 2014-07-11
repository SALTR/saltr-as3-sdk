/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.game.SLTAsset;

import saltr.game.SLTAssetState;
import saltr.game.SLTBoardLayer;
import saltr.game.SLTLevelParser;

public class SLT2DLevelParser extends SLTLevelParser {
    public function SLT2DLevelParser() {
    }

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
        if (boardNode.hasOwnProperty("properties") && boardNode.properties.hasOwnProperty("board")) {
            boardProperties = boardNode.properties.board;
        }


        var layers:Vector.<SLTBoardLayer> = new Vector.<SLTBoardLayer>();
        var layerNodes:Array = boardNode.layers;
        for (var i:int = 0, len:int = layerNodes.length; i < len; ++i) {
            var layerNode:Object = layerNodes[i];
            var layer:SLT2DBoardLayer = parseLayer(layerNode, i, assetMap);
            layers.push(layer);
        }

        return new SLT2DBoard(layers, boardProperties);
    }

    private function parseLayer(layerNode:Object, layerIndex:int, assetMap:Dictionary):SLT2DBoardLayer {
        var layerId:String = layerNode.layerId;
        var layer:SLT2DBoardLayer = new SLT2DBoardLayer(layerId, layerIndex);
        parseFixedAssets(layer, layerNode.fixedAssets as Array, assetMap);
        return layer;
    }

    private function parseFixedAssets(layer:SLT2DBoardLayer, assetNodes:Array, assetMap:Dictionary):void {
        //creating fixed asset instances and assigning them to cells where they belong
        for (var i:int = 0, iLen:int = assetNodes.length; i < iLen; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateIds:Array = assetInstanceNode.states as Array;

//            for (var j:int = 0, jLen:int = cellPositions.length; j < jLen; ++j) {
//                var position:Array = cellPositions[j];
////                var cell:SLTCell = cells.retrieve(position[0], position[1]);
////                cell.setAssetInstance(layer.layerId, layer.layerIndex, asset.getInstance(stateIds))
//            }
        }
    }

    override protected function parseAssetState(stateNode:Object):SLTAssetState {
        var token:String;
        var properties:Object = null;

        if (stateNode.hasOwnProperty("token")) {
            token = stateNode.token;
        }

        if (stateNode.hasOwnProperty("properties")) {
            properties = stateNode.properties;
        }

        return new SLTAssetState(token, properties);
    }
}
}
