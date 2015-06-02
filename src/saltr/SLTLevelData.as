/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;

public class SLTLevelData {

    private var _levelPacks:Vector.<SLTLevelPack>;


    public function SLTLevelData() {
        _levelPacks = new <SLTLevelPack>[];
    }

    public function get levelPacks():Vector.<SLTLevelPack> {
        return _levelPacks;
    }

    public function get allLevels():Vector.<SLTLevel> {
        var allLevels:Vector.<SLTLevel> = new Vector.<SLTLevel>();
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            var levels:Vector.<SLTLevel> = _levelPacks[i].levels;
            for (var j:int = 0, len2:int = levels.length; j < len2; ++j) {
                allLevels.push(levels[j]);
            }
        }

        return allLevels;
    }

    public function get allLevelsCount():uint {
        var count:uint = 0;
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            count += _levelPacks[i].levels.length;
        }
        return count;
    }

    public function getLevelByGlobalIndex(index:int):SLTLevel {
        if(index < 0) {
            return null;
        }
        var levelsSum:int = 0;
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            var packLength:int = _levelPacks[i].levels.length;
            if (index >= levelsSum + packLength) {
                levelsSum += packLength;
            } else {
                var localIndex:int = index - levelsSum;
                return _levelPacks[i].levels[localIndex];
            }
        }
        return null;
    }

    public function getPackByLevelGlobalIndex(index:int):SLTLevelPack {
        if(index < 0) {
            return null;
        }
        var levelsSum:int = 0;
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            var packLength:int = _levelPacks[i].levels.length;
            if (index >= levelsSum + packLength) {
                levelsSum += packLength;
            } else {
                return _levelPacks[i];
            }
        }
        return null;
    }

    public function initWithData(data:Object):void {
        try {
            var newLevelPacks:Vector.<SLTLevelPack> = SLTDeserializer.decodeLevels(data);
        } catch (e:Error) {
            throw new Error("Levels parse error");
        }


        if (newLevelPacks != null) {
            disposeLevelPacks();
            _levelPacks = newLevelPacks;
        }
    }

    private function disposeLevelPacks():void {
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            _levelPacks[i].dispose();
        }
        _levelPacks.length = 0;
    }
}
}
