package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTBoardLayer;
import saltr.saltr_internal;

use namespace saltr_internal;


internal class SLTMatchingBoardConfig {
    private var _matchingRulesEnabled:Boolean;
    private var _squareMatchingRuleEnabled:Boolean;
    private var _alternativeMatchAssets:Vector.<SLTChunkAssetDatum>;
    private var _excludedMatchAssets:Vector.<SLTChunkAssetDatum>;
    private var _blockedCells:Array;
    private var _cellProperties:Array;
    private var _cols:int;
    private var _rows:int;
    private var _cells:SLTCells;
    private var _assetMap:Dictionary;
    private var _layers:Vector.<SLTBoardLayer>;

    public function SLTMatchingBoardConfig(cells:SLTCells, layers:Vector.<SLTBoardLayer>, boardNode:Object, assetMap:Dictionary) {
        _assetMap = assetMap;

        _matchingRulesEnabled = boardNode.hasOwnProperty("matchingRulesEnabled") ? boardNode.matchingRulesEnabled : false;
        _squareMatchingRuleEnabled = boardNode.hasOwnProperty("squareMatchingRuleEnabled") ? boardNode.squareMatchingRuleEnabled : false;

        _alternativeMatchAssets = new <SLTChunkAssetDatum>[];
        if (boardNode.hasOwnProperty("alternativeMatchAssets")) {
            var alternativeAssetNodes:Array = boardNode.alternativeMatchAssets as Array;
            for each (var alternativeAssetNode:Object in alternativeAssetNodes) {
                _alternativeMatchAssets.push(new SLTChunkAssetDatum(alternativeAssetNode.assetId, alternativeAssetNode.states, _assetMap));
            }
        }

        _excludedMatchAssets = new <SLTChunkAssetDatum>[];
        if (boardNode.hasOwnProperty("excludedMatchAssets")) {
            var excludedAssetNodes:Array = boardNode.excludedMatchAssets as Array;
            for each (var excludedAssetNode:Object in excludedAssetNodes) {
                _excludedMatchAssets.push(new SLTChunkAssetDatum(excludedAssetNode.assetId, [excludedAssetNode.stateId], _assetMap));
            }
        }

        _blockedCells = boardNode.hasOwnProperty("blockedCells") ? boardNode.blockedCells : [];
        _cellProperties = boardNode.hasOwnProperty("cellProperties") ? boardNode.cellProperties : [];

        _cols = boardNode.cols;
        _rows = boardNode.rows;

        _cells = cells;
        _layers = layers;
    }

    saltr_internal function get blockedCells():Array {
        return _blockedCells;
    }

    saltr_internal function get cellProperties():Array {
        return _cellProperties;
    }

    saltr_internal function get cols():int {
        return _cols;
    }

    saltr_internal function get rows():int {
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

    saltr_internal function get alternativeMatchAssets():Vector.<SLTChunkAssetDatum> {
        return _alternativeMatchAssets;
    }

    saltr_internal function get excludedMatchAssets():Vector.<SLTChunkAssetDatum> {
        return _excludedMatchAssets;
    }

    saltr_internal function get layers():Vector.<SLTBoardLayer> {
        return _layers;
    }

    saltr_internal function get cells():SLTCells {
        return _cells;
    }

    saltr_internal function get assetMap():Dictionary {
        return _assetMap;
    }
}
}