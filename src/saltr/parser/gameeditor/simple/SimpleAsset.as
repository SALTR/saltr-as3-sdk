/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 11/9/12
 * Time: 5:02 PM
 */
package saltr.parser.gameeditor.simple {
import saltr.parser.gameeditor.BoardAsset;
import saltr.parser.gameeditor.Cell;

public class SimpleAsset extends BoardAsset {
    private var _cell:Cell;

    public function SimpleAsset() {
    }

    public function set cell(cell:Cell):void {
        _cell = cell;
    }

    public function get cell():Cell {
        return _cell;
    }

    public function toString():String {
        return "Asset : [type : " + _type + "]" + "[keys : " + _keys + "]" + "[state : " + _state + "]";
    }
}
}
