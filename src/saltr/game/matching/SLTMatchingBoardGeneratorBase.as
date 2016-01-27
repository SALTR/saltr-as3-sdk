/**
 * Created by TIGR on 3/25/2015.
 */
package saltr.game.matching {


import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.game.SLTAssetInstance;
import saltr.saltr_internal;

use namespace saltr_internal;

internal class SLTMatchingBoardGeneratorBase {


    saltr_internal static function getGenerator(boardConfig:SLTMatchingBoardConfig, layer:SLTMatchingBoardLayer):SLTMatchingBoardGeneratorBase {
        if (boardConfig.matchingRulesEnabled && isMatchingRuleEnabledLayer(layer)) {
            return SLTMatchingBoardRulesEnabledGenerator.getInstance();
        } else {
            return SLTMatchingBoardGenerator.getInstance();
        }
    }

    private static function isMatchingRuleEnabledLayer(layer:SLTMatchingBoardLayer):Boolean {
        var matchingRuleEnabled:Boolean = false;
        for (var i:int = 0, length:int = layer.chunks.length; i < length; ++i) {
            var chunk:SLTChunk = layer.chunks[i];
            if (chunk.matchingRuleEnabled) {
                matchingRuleEnabled = true;
                break;
            }
        }
        return matchingRuleEnabled;
    }

    saltr_internal function generate(boardConfig:SLTMatchingBoardConfig, layer:SLTMatchingBoardLayer):void {
        throw new Error("Abstract method error");
    }

    protected function generateAssetData(chunks:Vector.<SLTChunk>):void {
        for (var i:int = 0, len:int = chunks.length; i < len; ++i) {
            chunks[i].generateAssetData();
        }
    }

    protected function parseFixedAssets(layer:SLTMatchingBoardLayer, cells:SLTCells, assetMap:Dictionary):void {
        var assetNodes:Array = layer.assetRules;
        //creating fixed asset instances and assigning them to cells where they belong
        for (var i:int = 0, iLen:int = assetNodes.length; i < iLen; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateId:String = assetInstanceNode.stateId;

            var cell:SLTCell = cells.retrieve(assetInstanceNode.col, assetInstanceNode.row);
            cell.removeAssetInstance(layer.token, layer.index);
            var positions:Array = getAssetInstancePositions(assetInstanceNode);
            cell.setAssetInstance(layer.token, layer.index, new SLTAssetInstance(asset.token, asset.getInstanceState(stateId), asset.properties, positions));
        }
    }

    protected function fillLayerChunkAssets(chunks:Vector.<SLTChunk>):void {
        for (var i:uint = 0, chunksLength:int = chunks.length; i < chunksLength; ++i) {
            var chunk:SLTChunk = chunks[i];
            var availableAssetData:Vector.<SLTChunkAssetDatum> = chunk.availableAssetData.concat();
            var chunkCells:Vector.<SLTCell> = chunk.cells.concat();
            for (var j:uint = 0, cellsLength:int = chunkCells.length; j < cellsLength; ++j) {
                var assetDatumRandIndex:int = Math.random() * availableAssetData.length;
                var assetDatum:SLTChunkAssetDatum = availableAssetData[assetDatumRandIndex];
                availableAssetData.splice(assetDatumRandIndex, 1);
                chunk.addAssetInstanceWithCellIndex(assetDatum, j);
            }
        }
    }

    private function getAssetInstancePositions(assetInstanceNode:Object):Array {
        var positions:Array = [];
        var positionsArray:Array = assetInstanceNode.hasOwnProperty("altPositions") ? assetInstanceNode.altPositions as Array : [];
        var positionsCount:int = positionsArray.length;
        for (var i:int = 0; i < positionsCount; ++i) {
            var positionObject:Object = positionsArray[i];
            var placeHolder:SLTMatchingAssetPlaceHolder = new SLTMatchingAssetPlaceHolder(positionObject.col, positionObject.row, positionObject.tags);
            positions.push(placeHolder);
        }
        return positions;
    }
}
}
