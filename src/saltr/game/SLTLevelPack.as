/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
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

    public function dispose():void {
        // We are NOT disposing levels here as they still can be used by the app (references!).
        // We let levels to be garbage collected later if not used.
        _levels.length = 0;
        _levels = null;
    }

}
}
