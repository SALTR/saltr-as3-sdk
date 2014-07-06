/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
public class SLTAssetInstance {
    protected var _token:String;
    protected var _states:Vector.<SLTAssetState>;
    protected var _properties:Object;

    public function SLTAssetInstance(token:String, states:Vector.<SLTAssetState>, properties:Object) {
        _token = token;
        _states = states;
        _properties = properties
    }

    public function get token():String {
        return _token;
    }

    public function get states():Vector.<SLTAssetState> {
        return _states;
    }

    public function get properties():Object {
        return _properties;
    }

}
}
