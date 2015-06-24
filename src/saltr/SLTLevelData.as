/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;

use namespace saltr_internal;

public class SLTLevelData {

    private var _levels:Vector.<SLTLevel>;

    public function SLTLevelData() {
        _levels = new <SLTLevel>[];
    }

    public function get allLevels():Vector.<SLTLevel> {
        return _levels;
    }

    public function get allLevelsCount():uint {
        return _levels.length;
    }

    public function getLevelByGlobalIndex(index:int):SLTLevel {
        if(index < 0 || index >= _levels.length) {
            return null;
        }
        for(var i:int = 0, len:int = _levels.length; i < len; ++i) {
            var level:SLTLevel = _levels[i];
            if(index == level.globalIndex) {
                return level;
            }
        }
        return null;
    }

    public function initWithData(data:Object):void {
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
