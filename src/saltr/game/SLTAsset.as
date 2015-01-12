/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import flash.utils.Dictionary;

/**
 * The SLTAsset class represents the game asset.
 */
public class SLTAsset {
    protected var _properties:Object;
    protected var _stateMap:Dictionary;
    protected var _token:String;

    /**
     * Class constructor.
     * @param token The unique identifier of the asset.
     * @param stateMap The states.
     * @param properties The properties.
     */
    public function SLTAsset(token:String, stateMap:Dictionary, properties:Object) {
        _token = token;
        _stateMap = stateMap;
        _properties = properties;
    }

    /**
     * The unique identifier of the asset.
     */
    public function get token():String {
        return _token;
    }

    /**
     * The properties.
     */
    public function get properties():Object {
        return _properties;
    }

    /**
     * Returns token plus properties string.
     */
    public function toString():String {
        return "[Asset] token: " + _token + ", " + " properties: " + _properties;
    }

    /**
     * Returns instance states by provided state identifiers.
     * @param stateIds - The state identifiers.
     */
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
