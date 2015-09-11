/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import saltr.game.SLTLevel;

use namespace saltr_internal;

/**
 * The SLTLevelData class provides the level data.
 */
public class SLTLevelData {

    private var _levels:Vector.<SLTLevel>;

    /**
     * Class constructor.
     */
    public function SLTLevelData() {
        _levels = new <SLTLevel>[];
    }

    /**
     * All levels
     */
    public function get allLevels():Vector.<SLTLevel> {
        return _levels;
    }

    /**
     * All levels count.
     */
    public function get allLevelsCount():uint {
        return _levels.length;
    }

    /**
     * Provides level with given global index
     * @param index The global index
     */
    public function getLevelByGlobalIndex(index:int):SLTLevel {
        if (index < 0 || index >= _levels.length) {
            return null;
        }
        for (var i:int = 0, len:int = _levels.length; i < len; ++i) {
            var level:SLTLevel = _levels[i];
            if (index == level.globalIndex) {
                return level;
            }
        }
        return null;
    }

    /**
     * @private
     */
    saltr_internal function initWithData(data:Object):void {
        try {
            var newLevels:Vector.<SLTLevel> = SLTDeserializer.decodeLevels(data);
        } catch (e:Error) {
            throw new Error("Levels parse error");
        }


        if (newLevels != null) {
            disposeLevels();
            _levels = newLevels;
        }
    }

    private function disposeLevels():void {
        _levels.length = 0;
    }
}
}
