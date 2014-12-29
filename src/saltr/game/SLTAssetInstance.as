/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {

/**
 * The SLTAssetInstance class represents the game asset instance placed on board.
 * It holds the unique identifier of the asset and current instance related states and properties.
 */
public class SLTAssetInstance {
    protected var _token:String;
    protected var _states:Vector.<SLTAssetState>;
    protected var _properties:Object;

    /**
     * Class constructor.
     * @param token - The unique identifier of the asset.
     * @param states - The current instance states.
     * @param properties - The current instance properties.
     */
    public function SLTAssetInstance(token:String, states:Vector.<SLTAssetState>, properties:Object) {
        _token = token;
        _states = states;
        _properties = properties
    }

    /**
     * The unique identifier of the asset.
     */
    public function get token():String {
        return _token;
    }

    /**
     * The current instance states.
     */
    public function get states():Vector.<SLTAssetState> {
        return _states;
    }

    /**
     * The current instance properties.
     */
    public function get properties():Object {
        return _properties;
    }

}
}
