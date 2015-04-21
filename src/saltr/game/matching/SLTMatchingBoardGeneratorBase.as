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
        for (var i:int = 0; i < layer.chunks.length; ++i) {
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

    protected function generateAssetData(layer:SLTMatchingBoardLayer):void {
        for (var i:int = 0, len:int = layer.chunks.length; i < len; ++i) {
            layer.chunks[i].generateAssetData();
        }
    }

    protected function parseFixedAssets(layer:SLTMatchingBoardLayer, cells:SLTCells, assetMap:Dictionary):void {
        var assetNodes:Array = layer.fixedAssets;
        //creating fixed asset instances and assigning them to cells where they belong
        for (var i:int = 0, iLen:int = assetNodes.length; i < iLen; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateIds:Array = assetInstanceNode.states as Array;
            var cellPositions:Array = assetInstanceNode.cells;

            for (var j:int = 0, jLen:int = cellPositions.length; j < jLen; ++j) {
                var position:Array = cellPositions[j];
                var cell:SLTCell = cells.retrieve(position[0], position[1]);
                cell.removeAssetInstance(layer.token, layer.index);
                cell.setAssetInstance(layer.token, layer.index, new SLTAssetInstance(asset.token, asset.getInstanceStates(stateIds), asset.properties));
            }
        }
    }
}
}
