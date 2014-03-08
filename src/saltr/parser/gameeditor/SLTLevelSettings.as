/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 11/9/12
 * Time: 5:27 PM
 */
package saltr.parser.gameeditor {
import flash.utils.Dictionary;

public class SLTLevelSettings {
    private var _assetMap:Dictionary;
    private var _keySetMap:Object;
    private var _stateMap:Dictionary;

    public function SLTLevelSettings(assetMap:Dictionary, keySetMap:Object, stateMap:Dictionary) {
        _assetMap = assetMap;
        _keySetMap = keySetMap;
        _stateMap = stateMap;
    }

    public function get assetMap():Dictionary {
        return _assetMap;
    }

    public function get keySetMap():Object {
        return _keySetMap;
    }

    public function get stateMap():Dictionary {
        return _stateMap;
    }

}
}
