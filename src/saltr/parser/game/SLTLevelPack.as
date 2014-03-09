/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 10/23/12
 * Time: 3:48 PM
 */
package saltr.parser.game {
public class SLTLevelPack {
    private var _token:String;
    private var _levels:Vector.<SLTLevel>;
    private var _index:int;

    public function SLTLevelPack(token:String, index:int, levels:Vector.<SLTLevel>) {
        _token = token;
        _index = index;
        _levels = levels;
    }

    public function get token():String {
        return _token;
    }

    public function get levels():Vector.<SLTLevel> {
        return _levels;
    }

    public function get index():int {
        return _index;
    }

    public function toString():String {
        return _token;
    }

}
}
