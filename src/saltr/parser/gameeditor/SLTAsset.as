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
package saltr.parser.gameeditor {
public class SLTAsset {
    private var _keys:Object;
    private var _type:String;

    public function SLTAsset(typeKey:String, keys:Object) {
        _type = typeKey;
        _keys = keys;
    }

    public function get keys():Object {
        return _keys;
    }

    public function get type():String {
        return _type;
    }

    public function toString():String {
        return "AssetTemplate : [type : " + _type + "]" + "[keys : " + _keys + "]";
    }
}
}
