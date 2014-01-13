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
    private var _data:Object;

    public function Feature(token:String, data:Object) {
        _token = token;
        _data = data;
    }

    public function toString():String {
        return "Feature { token : " + _token + " , data : " + _data + "}";
    }


    public function get token():String {
        return _token;
    }

    public function get data():Object {
        return _data;
    }
}
}
