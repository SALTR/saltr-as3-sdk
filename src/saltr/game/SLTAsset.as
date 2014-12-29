/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import flash.utils.Dictionary;

public class SLTAsset {
    protected var _properties:Object;
    protected var _stateMap:Dictionary;
    protected var _token:String;

    public function SLTAsset(token:String, stateMap:Dictionary, properties:Object) {
        _token = token;
        _stateMap = stateMap;
        _properties = properties;
    }

    public function get token():String {
        return _token;
    }

    public function get properties():Object {
        return _properties;
    }

    public function toString():String {
        return "[Asset] token: " + _token + ", " + " properties: " + _properties;
    }

    public function getInstanceStates(stateIds:Array):Vector.<SLTAssetState> {
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
