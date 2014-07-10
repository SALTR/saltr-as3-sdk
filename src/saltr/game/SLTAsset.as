/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import saltr.parser.game.*;

import flash.utils.Dictionary;

internal class SLTAsset {
    protected var _properties:Object;
    protected var _stateMap:Dictionary;
    protected var _token:String;

    public function SLTAsset(token:String, stateMap:Dictionary, properties:Object) {
        _token = token;
        _stateMap = stateMap;
        _properties = properties;
    }

    internal function get token():String {
        return _token;
    }

    internal function get properties():Object {
        return _properties;
    }

    public function toString():String {
        return "[Asset] token: " + _token + ", " + " properties: " + _properties;
    }

    internal function getInstance(stateIds:Array):SLTAssetInstance {
        return new SLTAssetInstance(_token, getInstanceStates(stateIds), properties);
    }

    protected function getInstanceStates(stateIds:Array):Vector.<SLTAssetState> {
        var states:Vector.<SLTAssetState> = new Vector.<SLTAssetState>();
        for (var i:int = 0, len:int = stateIds.length; i < len; ++i) {
            var state:SLTAssetState = _stateMap[stateIds[i]] as SLTAssetState;
            if (state != null) {
                states.push(state);
            }
        }
        return states;
    }
}
}
