/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: sarg
 * Date: 4/12/12
 * Time: 7:27 PM
 */
package saltr.parser.game {
internal class SLTChunkAssetRule {

    private var _assetId:String;
    private var _stateId:String;
    private var _distributionType:String;
    private var _distributionValue:uint;

    public function SLTChunkAssetRule(assetId:String, distributionType:String,  distributionValue:uint, stateId:String) {

        _assetId = assetId;
        _distributionType = distributionType;
        _distributionValue = distributionValue;
        _stateId = stateId;
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

    public function get stateId():String {
        return _stateId;
    }
}
}
