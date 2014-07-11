/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
public class SLTLevelPack {
    private var _token:String;
    private var _levels:Vector.<SLTMatchingLevel>;
    private var _index:int;

    public function SLTLevelPack(token:String, index:int, levels:Vector.<SLTMatchingLevel>) {
        _token = token;
        _index = index;
        _levels = levels;
    }

    public function get token():String {
        return _token;
    }

    public function get levels():Vector.<SLTMatchingLevel> {
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
