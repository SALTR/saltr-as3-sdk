/**
 * Created by TIGR on 3/18/2015.
 */
package saltr.game.matching {

/**
 * The SLTMatchingRuleAsset class represents the matching rule asset.
 */
internal class SLTMatchingRuleAsset {
    private var _assetId:String;
    private var _stateId:String;

    /**
     * Class constructor.
     * @param assetId The asset identifier.
     * @param stateId The state identifier.
     */
    public function SLTMatchingRuleAsset(assetId:String, stateId:String) {
        _assetId = assetId;
        _stateId = stateId;
    }

    /**
     * The asset identifier.
     */
    public function get assetId():String {
        return _assetId;
    }

    /**
     * The state identifier.
     */
    public function get stateId():String {
        return _stateId;
    }
}
}
