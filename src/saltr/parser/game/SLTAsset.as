/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: sarg
 * Date: 11/10/12
 * Time: 12:31 PM
 */
package saltr.parser.game {
internal class SLTAsset {
    private var _properties:Object;
    private var _token:String;

    public function SLTAsset(token:String, properties:Object) {
        _token = token;
        _properties = properties;
    }

    public function get token():String {
        return _token;
    }

    public function get properties():Object {
        return _properties;
    }

    public function toString():String {
        return "[Asset] token: " + _token + ", " + " properties: " + _properties;
    }
}
}
