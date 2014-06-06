/*
 * Copyright (c) 2014 Plexonic Ltd
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
