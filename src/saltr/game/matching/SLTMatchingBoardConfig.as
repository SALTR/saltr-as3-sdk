package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;


internal class SLTMatchingBoardConfig {
    private var _matchingRules:SLTMatchingRules;
    private var _blockedCells:Array;
    private var _cellProperties:Array;
    private var _cols:int;
    private var _rows:int;
    private var _cells:SLTCells;
    private var _assetMap:Dictionary;
    private var _layers:Dictionary;

    public function SLTMatchingBoardConfig(cells:SLTCells, layers:Dictionary, boardNode:Object, assetMap:Dictionary, matchingRules:SLTMatchingRules) {
        _assetMap = assetMap;
        _matchingRules = matchingRules;
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
        return _matchingRules.matchingRuleEnabled;
    }

    /**
     * The matching size.
     */
    saltr_internal function get matchSize():int {
        return _matchingRules.matchSize;
    }

    /**
     * The square matching rules enabled state.
     */
    saltr_internal function get squareMatchingRuleEnabled():Boolean {
        return _matchingRules.squareMatchEnabled;
    }

    saltr_internal function get excludedMatchAssets():Vector.<SLTChunkAssetDatum> {
        return _matchingRules.excludedAssets;
    }

    saltr_internal function get layers():Dictionary {
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