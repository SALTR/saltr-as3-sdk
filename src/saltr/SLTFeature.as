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
    private var _token:String;
    private var _type:String;
    private var _properties:Object;
    private var _required:Boolean;
    private var _isValid:Boolean;

    public function SLTFeature(token:String, type:String, properties:Object = null, required:Boolean = false) {
        _token = token;
        _type = type;
        _properties = properties;
        _required = required;
        _isValid = true;
    }

    saltr_internal function get token():String {
        return _token;
    }

    saltr_internal function get type():String {
        return _type;
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

    saltr_internal function get isValid():Boolean {
        return _isValid;
    }

    saltr_internal function set isValid(value:Boolean):void {
        _isValid = value;
    }
}
}
