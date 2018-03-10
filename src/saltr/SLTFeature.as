/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
use namespace saltr_internal;

/**
 * @private
 */
public class SLTFeature {
    private var _token:String;
    private var _type:String;
    private var _body:Object;
    private var _required:Boolean;
    private var _isValid:Boolean;
    private var _version:String;

    public function SLTFeature(token:String, type:String, version:String, body:Object = null, required:Boolean = false) {
        _token = token;
        _type = type;
        _body = body;
        _required = required;
        _isValid = true;
        _version = version;
    }

    saltr_internal function get token():String {
        return _token;
    }

    saltr_internal function get type():String {
        return _type;
    }

    saltr_internal function get body():Object {
        return _body;
    }

    saltr_internal function get required():Boolean {
        return _required;
    }

    saltr_internal function get version():String {
        return _version;
    }

    saltr_internal function toString():String {
        return "[SALTR] Feature { token : " + _token + ", value : " + _body + "}";
    }

    saltr_internal function get isValid():Boolean {
        return _isValid;
    }

    saltr_internal function set isValid(value:Boolean):void {
        _isValid = value;
    }
}
}
