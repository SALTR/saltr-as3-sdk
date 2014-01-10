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
package plexonic.saltr.parser.gameeditor {
import de.polygonal.ds.Map;

public class BoardData {
    private var _assetMap:Map;
    private var _keyset:Object;
    private var _stateMap:Map;

    public function BoardData() {
    }

    public function get assetMap():Map {
        return _assetMap;
    }

    public function set assetMap(value:Map):void {
        _assetMap = value;
    }

    public function get keyset():Object {
        return _keyset;
    }

    public function set keyset(value:Object):void {
        _keyset = value;
    }

    public function get stateMap():Map {
        return _stateMap;
    }

    public function set stateMap(value:Map):void {
        _stateMap = value;
    }

}
}
