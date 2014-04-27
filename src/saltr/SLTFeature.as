/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: daal
 * Date: 6/12/12
 * Time: 2:03 PM
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
