/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
internal class SLTChunkAssetRule {

    private var _assetId:String;
    private var _stateIds:Array;
    private var _distributionType:String;
    private var _distributionValue:uint;

    public function SLTChunkAssetRule(assetId:String, distributionType:String, distributionValue:uint, stateIds:Array) {

        _assetId = assetId;
        _distributionType = distributionType;
        _distributionValue = distributionValue;
        _stateIds = stateIds;
    }

    public function get assetId():String {
        return _assetId;
    }

    public function get distributionValue():uint {
        return _distributionValue;
    }

    public function get distributionType():String {
        return _distributionType;
    }

    public function get stateIds():Array {
        return _stateIds;
    }
}
}
