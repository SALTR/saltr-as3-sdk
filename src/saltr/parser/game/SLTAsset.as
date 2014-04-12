/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
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
