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
            var cellPositions:Array = assetInstanceNode.cells;

            for (var j:int = 0, jLen:int = cellPositions.length; j < jLen; ++j) {
                var position:Array = cellPositions[j];
                var cell:SLTCell = cells.retrieve(position[0], position[1]);
                cell.removeAssetInstance(layer.token, layer.index);
                cell.setAssetInstance(layer.token, layer.index, new SLTAssetInstance(asset.token, asset.getInstanceState(stateId), asset.properties));
            }
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
                availableAssetData.removeAt(assetDatumRandIndex);
                chunk.addAssetInstanceWithCellIndex(assetDatum, j);
            }
        }
    }
}
}
