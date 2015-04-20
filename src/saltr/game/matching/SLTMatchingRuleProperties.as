/**
 * Created by TIGR on 4/20/2015.
 */
package saltr.game.matching {
import saltr.saltr_internal;

public class SLTMatchingRuleProperties {
    private var _matchingRuleEnabled:Boolean;
    private var _matchSize:int;
    private var _squareRuleEnabled:Boolean;
    private var _excludedAssets:Vector.<SLTChunkAssetDatum>;

    public function SLTMatchingRuleProperties() {
        _matchingRuleEnabled = false;
        _matchSize = 0;
        _squareRuleEnabled = false;
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

    saltr_internal function get squareRuleEnabled():Boolean {
        return _squareRuleEnabled;
    }

    saltr_internal function set squareRuleEnabled(value:Boolean):void {
        _squareRuleEnabled = value;
    }

    saltr_internal function get excludedAssets():Vector.<SLTChunkAssetDatum> {
        return _excludedAssets;
    }

    saltr_internal function set excludedAssets(value:Vector.<SLTChunkAssetDatum>):void {
        _excludedAssets = value;
    }
}
}
