/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTFeature {
    protected var _token:String;
    protected var _properties:Object;
    protected var _required:Boolean;

    public function SLTFeature(token:String, properties:Object = null, required:Boolean = false) {
        _token = token;
        _properties = properties;
        _required = required;
    }

    saltr_internal function get token():String {
        return _token;
    }

    saltr_internal function get properties():Object {
        return _properties;
    }

    saltr_internal function get required():Boolean {
        return _required;
    }

    saltr_internal function toString():String {
        return "[SALTR] Feature { token : " + _token + ", value : " + _properties + "}";
    }
}
}
