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

//    public function get levelPacks():Vector.<SLTLevelPack> {
//        return _levelPacks;
//    }

    public function get allLevels():Vector.<SLTLevel> {
        return _levels;
//        var allLevels:Vector.<SLTLevel> = new Vector.<SLTLevel>();
//        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
//            var levels:Vector.<SLTLevel> = _levelPacks[i].levels;
//            for (var j:int = 0, len2:int = levels.length; j < len2; ++j) {
//                allLevels.push(levels[j]);
//            }
//        }
//
//        return allLevels;
    }

    public function get allLevelsCount():uint {
        return _levels.length;
//        var count:uint = 0;
//        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
//            count += _levelPacks[i].levels.length;
//        }
//        return count;
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
//        var levelsSum:int = 0;
//        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
//            var packLength:int = _levelPacks[i].levels.length;
//            if (index >= levelsSum + packLength) {
//                levelsSum += packLength;
//            } else {
//                var localIndex:int = index - levelsSum;
//                return _levelPacks[i].levels[localIndex];
//            }
//        }
//        return null;
    }

//    public function getPackByLevelGlobalIndex(index:int):SLTLevelPack {
//        if(index < 0) {
//            return null;
//        }
//        var levelsSum:int = 0;
//        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
//            var packLength:int = _levelPacks[i].levels.length;
//            if (index >= levelsSum + packLength) {
//                levelsSum += packLength;
//            } else {
//                return _levelPacks[i];
//            }
//        }
//        return null;
//    }

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

//    private function disposeLevelPacks():void {
//        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
//            _levelPacks[i].dispose();
//        }
//        _levelPacks.length = 0;
//    }
}
}
