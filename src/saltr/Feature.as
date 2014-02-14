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
public class Feature {
    private var _token:String;
    private var _properties:Object;
    private var _defaultProperties : Object;

    public function Feature(token:String, data:Object = null, defaultValue : Object = null) {
        _token = token;
        _properties = data;
        _defaultProperties = defaultValue;
    }

    public function get token():String {
        return _token;
    }

    public function get properties():Object {
        return _properties == null ? _defaultProperties : _properties;
    }

    public function get defaultProperties() : Object {
        return _defaultProperties;
    }

    public function set defaultProperties(value : Object) : void {
        _defaultProperties = value;
    }

    public function toString():String {
        return "Feature { token : " + _token + " , value : " + _properties + "}";
    }
}
}
