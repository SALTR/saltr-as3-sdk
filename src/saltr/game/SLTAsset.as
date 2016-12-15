/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import flash.utils.Dictionary;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTAsset class represents the game asset.
 * @private
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
    saltr_internal function get token():String {
        return _token;
    }

    /**
     * The properties.
     */
    saltr_internal function get properties():Object {
        return _properties;
    }

    /**
     * Returns instance states by provided state identifiers.
     * @param stateId The state identifier.
     */
    saltr_internal function getInstanceState(stateId:String):SLTAssetState {
        return _stateMap[stateId] as SLTAssetState;
    }

    /**
     * Returns token plus properties string.
     */
    saltr_internal function toString():String {
        return "[Asset] token: " + _token + ", " + " properties: " + _properties;
    }
}
}
