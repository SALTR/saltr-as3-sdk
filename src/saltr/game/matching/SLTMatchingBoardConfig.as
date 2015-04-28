package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTBoardLayer;
import saltr.saltr_internal;

use namespace saltr_internal;


internal class SLTMatchingBoardConfig {
    private var _matchingRuleProperties:SLTMatchingRuleProperties;
    private var _blockedCells:Array;
    private var _cellProperties:Array;
    private var _cols:int;
    private var _rows:int;
    private var _cells:SLTCells;
    private var _assetMap:Dictionary;
    private var _layers:Vector.<SLTBoardLayer>;

    public function SLTMatchingBoardConfig(cells:SLTCells, layers:Vector.<SLTBoardLayer>, boardNode:Object, assetMap:Dictionary, matchingRuleProperties:SLTMatchingRuleProperties) {
        _assetMap = assetMap;
        _matchingRuleProperties = matchingRuleProperties;
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
        return _matchingRuleProperties.matchingRuleEnabled;
    }

    /**
     * The matching size.
     */
    saltr_internal function get matchSize():int {
        return _matchingRuleProperties.matchSize;
    }

    /**
     * The square matching rules enabled state.
     */
    saltr_internal function get squareMatchingRuleEnabled():Boolean {
        return _matchingRuleProperties.squareRuleEnabled;
    }

    saltr_internal function get excludedMatchAssets():Vector.<SLTChunkAssetDatum> {
        return _matchingRuleProperties.excludedAssets;
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