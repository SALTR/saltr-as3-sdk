/**
 * Created by Tigran Hakobyan on 3/25/2015.
 */
package saltr.game.matching {
import saltr.saltr_internal;

use namespace saltr_internal;

internal class SLTMatchingBoardImpl {
    private var _board:SLTMatchingBoard;
    private var _matchingRulesEnabled:Boolean;
    private var _squareMatchingRuleEnabled:Boolean;
    private var _alternativeMatchAssets:Vector.<SLTMatchingRuleAsset>;
    private var _excludedMatchAssets:Vector.<SLTMatchingRuleAsset>;

    private static function getGenerator(layerImpl:SLTMatchingBoardLayerImpl):ISLTMatchingBoardGenerator {
        if (layerImpl.matchingRulesEnabled) {
            return SLTMatchingBoardRulesEnabledGenerator.getInstance();
        } else {
            return SLTMatchingBoardGenerator.getInstance();
        }
    }

    public function SLTMatchingBoardImpl(board:SLTMatchingBoard, matchingRulesEnabled:Boolean, squareMatchingRuleEnabled:Boolean, alternativeMatchAssets:Vector.<SLTMatchingRuleAsset>, excludedMatchAssets:Vector.<SLTMatchingRuleAsset>) {
        _board = board;
        _matchingRulesEnabled = matchingRulesEnabled;
        _squareMatchingRuleEnabled = squareMatchingRuleEnabled;
        _alternativeMatchAssets = alternativeMatchAssets;
        _excludedMatchAssets = excludedMatchAssets;
    }

    saltr_internal function regenerate():void {
        for (var i:int = 0, len:int = _board.layers.length; i < len; ++i) {
            var layerImpl:SLTMatchingBoardLayerImpl = (_board.layers[i] as SLTMatchingBoardLayer).implementation as SLTMatchingBoardLayerImpl;
            var generator:ISLTMatchingBoardGenerator = getGenerator(layerImpl);
            generator.generate(this, layerImpl);
        }
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

    saltr_internal function get cells():SLTCells {
        return _board.cells;
    }

    saltr_internal function get rows():int {
        return _board.rows;
    }

    /**
     * The number of columns.
     */
    saltr_internal function get cols():int {
        return _board.cols;
    }
}
}
