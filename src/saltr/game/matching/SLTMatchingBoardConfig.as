package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.game.SLTAssetInstance;

import saltr.game.SLTBoardLayer;

import saltr.saltr_internal;

use namespace saltr_internal;


public class SLTMatchingBoardConfig {
    private var _matchingRulesEnabled:Boolean;
    private var _squareMatchingRuleEnabled:Boolean;
    private var _alternativeMatchAssets:Vector.<SLTMatchingRuleAsset>;
    private var _excludedMatchAssets:Vector.<SLTMatchingRuleAsset>;
    private var _blockedCells:Array;
    private var _cellProperties:Array;
    private var _cols:int;
    private var _rows:int;
    private var _cells:SLTCells;
    private var _assetMap:Dictionary;
    private var _layers:Vector.<SLTBoardLayer>;

    public function SLTMatchingBoardConfig(cells:SLTCells, layers : Vector.<SLTBoardLayer>, boardNode:Object, assetMap : Dictionary) {
        _assetMap = assetMap;


        _matchingRulesEnabled = boardNode.hasOwnProperty("matchingRulesEnabled") ? boardNode.matchingRulesEnabled : false;
        _squareMatchingRuleEnabled = boardNode.hasOwnProperty("squareMatchingRuleEnabled") ? boardNode.squareMatchingRuleEnabled : false;


        var _alternativeMatchAssets:Vector.<SLTMatchingRuleAsset> = new <SLTMatchingRuleAsset>[];
        if (boardNode.hasOwnProperty("alternativeMatchAssets")) {
            var alternativeAssetNodes:Array = boardNode.alternativeMatchAssets as Array;
            for each (var alternativeAssetNode:Object in alternativeAssetNodes) {
                _alternativeMatchAssets.push(new SLTMatchingRuleAsset(alternativeAssetNode.assetId, alternativeAssetNode.stateId));
            }
        }

        var _excludedMatchAssets:Vector.<SLTMatchingRuleAsset> = new <SLTMatchingRuleAsset>[];
        if (boardNode.hasOwnProperty("excludedMatchAssets")) {
            var excludedAssetNodes:Array = boardNode.excludedMatchAssets as Array;
            for each (var excludedAssetNode:Object in excludedAssetNodes) {
                _excludedMatchAssets.push(new SLTMatchingRuleAsset(excludedAssetNode.assetId, excludedAssetNode.stateId));
            }
        }

        _blockedCells = boardNode.hasOwnProperty("blockedCells") ? boardNode.blockedCells : [];
        _cellProperties = boardNode.hasOwnProperty("cellProperties") ? boardNode.cellProperties : [];

        _cols = boardNode.cols;
        _rows = boardNode.row;

        _cells = cells;
        _layers = layers;
    }

    private function parseFixedAssets(layer:SLTMatchingBoardLayer, assetNodes:Array, cells:SLTCells, assetMap:Dictionary):void {
        //creating fixed asset instances and assigning them to cells where they belong
        for (var i:int = 0, iLen:int = assetNodes.length; i < iLen; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateIds:Array = assetInstanceNode.states as Array;
            var cellPositions:Array = assetInstanceNode.cells;

            for (var j:int = 0, jLen:int = cellPositions.length; j < jLen; ++j) {
                var position:Array = cellPositions[j];
                var cell:SLTCell = cells.retrieve(position[0], position[1]);
                cell.setAssetInstance(layer.token, layer.index, new SLTAssetInstance(asset.token, asset.getInstanceStates(stateIds), asset.properties));
            }
        }
    }

    public function get blockedCells():Array {
        return _blockedCells;
    }

    public function get cellProperties():Array {
        return _cellProperties;
    }

    public function get cols():int {
        return _cols;
    }

    public function get rows():int {
        return _rows;
    }

    /**
     * The matching rules enabled state.
     */
    saltr_internal function get matchingRulesEnabled():Boolean {
        return _matchingRulesEnabled;
    }

    /**
     * The square matching rules enabled state.
     */
    saltr_internal function get squareMatchingRuleEnabled():Boolean {
        return _squareMatchingRuleEnabled;
    }

    saltr_internal function get alternativeMatchAssets():Vector.<SLTMatchingRuleAsset> {
        return _alternativeMatchAssets;
    }

    saltr_internal function get excludedMatchAssets():Vector.<SLTMatchingRuleAsset> {
        return _excludedMatchAssets;
    }

    public function get layers():Vector.<SLTBoardLayer> {
        return _layers;
    }

    public function get cells():SLTCells {
        return _cells;
    }

    public function get assetMap():Dictionary {
        return _assetMap;
    }
}


}