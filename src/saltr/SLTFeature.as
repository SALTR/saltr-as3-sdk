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
    private var _isRequired:Boolean;
    private var _version:String;
    private var _disabled:Boolean;

    public function SLTFeature(token:String, type:String, version:String, body:Object = null, isRequired:Boolean = false) {
        _token = token;
        _type = type;
        _body = body;
        _isRequired = isRequired;
        _version = version;
        _disabled = false;
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

    saltr_internal function get isRequired():Boolean {
        return _isRequired;
    }

    saltr_internal function get version():String {
        return _version;
    }

    saltr_internal function toString():String {
        return "[SALTR] Feature { token : " + _token + ", value : " + _body + "}";
    }

    public function get disabled():Boolean {
        return _disabled;
    }

    public function set disabled(value:Boolean):void {
        _disabled = _isRequired ? false : value;
    }

    public function update(version:String, newBody:Object = null):void {
        _version = version;
        if (newBody != null) {
            _body = newBody;
        }
    }
}
}
