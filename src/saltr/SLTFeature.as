/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
internal class SLTFeature {
    private var _token:String;
    private var _properties:Object;
    private var _required:Boolean;

    public function SLTFeature(token:String, properties:Object = null, required:Boolean = false) {
        _token = token;
        _properties = properties;
        _required = required;
    }

    public function get token():String {
        return _token;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get required():Boolean {
        return _required;
    }

    public function toString():String {
        return "[SALTR] Feature { token : " + _token + ", value : " + _properties + "}";
    }
}
}
