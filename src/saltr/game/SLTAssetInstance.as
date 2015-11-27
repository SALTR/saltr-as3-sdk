/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import flash.utils.Dictionary;

/**
 * The SLTAssetInstance class represents the game asset instance placed on board.
 * It holds the unique identifier of the asset and current instance related states and properties.
 */
public class SLTAssetInstance {
    protected var _token:String;
    protected var _state:SLTAssetState;
    protected var _properties:Object;
    protected var _positions:Dictionary;

    /**
     * Class constructor.
     * @param token The unique identifier of the asset.
     * @param state The current instance state.
     * @param properties The current instance properties.
     */
    public function SLTAssetInstance(token:String, state:SLTAssetState, properties:Object, positions:Dictionary = null) {
        _token = token;
        _state = state;
        _properties = properties;
        _positions = positions;
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
    public function get state():SLTAssetState {
        return _state;
    }

    /**
     * The current instance properties.
     */
    public function get properties():Object {
        return _properties;
    }

    /**
     * The current instance positions.
     */
    public function get positions():Dictionary {
        return _positions;
    }

}
}
