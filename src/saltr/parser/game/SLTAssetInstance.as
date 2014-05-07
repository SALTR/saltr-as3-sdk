/*
 * Copyright Plexonic Ltd (c) 2014.
 */

/**
 * User: sarg
 * Date: 8/2/13
 * Time: 5:28 PM
 */
package saltr.parser.game {
public class SLTAssetInstance {
    protected var _properties:Object;
    protected var _state:String;
    protected var _token:String;

    public function SLTAssetInstance(token:String, state:String, properties:Object) {
        _properties = properties;
        _state = state;
        _token = token;
    }

    public function get token():String {
        return _token;
    }

    public function get state():String {
        return _state;
    }

    public function get properties():Object {
        return _properties;
    }

}
}
