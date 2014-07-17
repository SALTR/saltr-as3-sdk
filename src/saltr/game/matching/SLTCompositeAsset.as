/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {

import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.game.SLTAssetInstance;

internal class SLTCompositeAsset extends SLTAsset {

    private var _cellInfos:Array;

    public function SLTCompositeAsset(token:String, cellInfos:Array, stateNodesMap:Dictionary, properties:Object) {
        super(token, stateNodesMap, properties);
        _cellInfos = cellInfos;
    }

    public function get cellInfos():Array {
        return _cellInfos;
    }

    override public function getInstance(stateIds:Array):SLTAssetInstance {
        return new SLTCompositeInstance(_token, getInstanceStates(stateIds), properties, _cellInfos);
    }

}
}
