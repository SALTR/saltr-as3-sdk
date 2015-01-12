/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {

/**
 * The SLTLevelPack class represents the collection of levels.
 */
public class SLTLevelPack {
    private var _token:String;
    private var _levels:Vector.<SLTLevel>;
    private var _index:int;

    /**
     * Class constructor.
     * @param token The unique identifier of the level pack.
     * @param index The index of the level pack.
     * @param levels The levels of the pack.
     */
    public function SLTLevelPack(token:String, index:int, levels:Vector.<SLTLevel>) {
        _token = token;
        _index = index;
        _levels = levels;
    }

    /**
     * The unique identifier of the level pack.
     */
    public function get token():String {
        return _token;
    }

    /**
     * The levels of the pack.
     */
    public function get levels():Vector.<SLTLevel> {
        return _levels;
    }

    /**
     * The index of the level pack.
     */
    public function get index():int {
        return _index;
    }

    /**
     * Returns the token.
     */
    public function toString():String {
        return _token;
    }

    /**
     * The dispose method.
     */
    public function dispose():void {
        // We are NOT disposing levels here as they still can be used by the app (references!).
        // We let levels to be garbage collected later if not used.
        _levels.length = 0;
        _levels = null;
    }

}
}
