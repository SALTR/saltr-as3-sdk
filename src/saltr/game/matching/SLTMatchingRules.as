/**
 * Created by TIGR on 4/20/2015.
 */
package saltr.game.matching {
import saltr.saltr_internal;

/**
 * @private
 */
public class SLTMatchingRules {
    public static const MATCHING_RULES:String = "matchingRules";

    private var _matchingRuleEnabled:Boolean;
    private var _matchSize:int;
    private var _squareMatchEnabled:Boolean;
    private var _excludedAssets:Vector.<SLTChunkAssetDatum>;

    public function SLTMatchingRules() {
        _matchingRuleEnabled = false;
        _matchSize = 0;
        _squareMatchEnabled = false;
        _excludedAssets = null;
    }

    saltr_internal function get matchingRuleEnabled():Boolean {
        return _matchingRuleEnabled;
    }

    saltr_internal function set matchingRuleEnabled(value:Boolean):void {
        _matchingRuleEnabled = value;
    }

    saltr_internal function get matchSize():int {
        return _matchSize;
    }

    saltr_internal function set matchSize(value:int):void {
        _matchSize = value;
    }

    saltr_internal function get squareMatchEnabled():Boolean {
        return _squareMatchEnabled;
    }

    saltr_internal function set squareRuleEnabled(value:Boolean):void {
        _squareMatchEnabled = value;
    }

    saltr_internal function get excludedAssets():Vector.<SLTChunkAssetDatum> {
        return _excludedAssets;
    }

    saltr_internal function set excludedAssets(value:Vector.<SLTChunkAssetDatum>):void {
        _excludedAssets = value;
    }
}
}
