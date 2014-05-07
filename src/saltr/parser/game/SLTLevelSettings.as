/*
 * Copyright Plexonic Ltd (c) 2014.
 */

/**
 * User: sarg
 * Date: 11/9/12
 * Time: 5:27 PM
 */
package saltr.parser.game {
import flash.utils.Dictionary;

internal class SLTLevelSettings {
    private var _assetMap:Dictionary;
    private var _stateMap:Dictionary;

    public function SLTLevelSettings(assetMap:Dictionary, stateMap:Dictionary) {
        _assetMap = assetMap;
        _stateMap = stateMap;
    }

    public function get assetMap():Dictionary {
        return _assetMap;
    }

    public function get stateMap():Dictionary {
        return _stateMap;
    }

}
}
