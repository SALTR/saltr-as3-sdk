/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.game.SLTLevel;
import saltr.saltr_internal;
import saltr.status.SLTStatus;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTMobileLevelCollectionUpdater extends EventDispatcher {
    private static const LEVEL_UPDATE_TIMER_DELAY:Number = 3000;
    private static const DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT:uint = 3;

    private var _levelCollectionFeatureToken:String;
    private var _outdatedLevels:Vector.<SLTLevel>;
    private var _updatedLevelCount:uint;
    private var _levelIndexToUpdate:int;
    private var _levelUpdateTimer:Timer;
    private var _allLevels:Vector.<SLTLevel>;
    private var _levelContentLoader:SLTMobileLevelContentLoader;
    private var _isInProcess:Boolean;
    private var _isCancelled:Boolean;

    public function SLTMobileLevelCollectionUpdater(featureToken:String, allLevels:Vector.<SLTLevel>, nativeTimeout:int, dropTimeout:int, timeoutIncrease:int) {
        _levelContentLoader = new SLTMobileLevelContentLoader(nativeTimeout, dropTimeout, timeoutIncrease);
        _isCancelled = false;
        resetUpdateProcess();
        _levelCollectionFeatureToken = featureToken;
        _allLevels = allLevels;
        _outdatedLevels = getOutdatedLevels();
    }

    public function update():void {
        SLTLogger.getInstance().log("Game levels group update called. featureToken: " + _levelCollectionFeatureToken + ", outdated Levels length: " + _outdatedLevels.length);
        if (_isInProcess) {
            throw new Error("SLTMobileLevelGroupUpdater is in processing.");
        }
        if (_outdatedLevels.length > 0) {
            _levelIndexToUpdate = 0;
            _isInProcess = true;
            startNextLevelsUpdate();
            startLevelUpdateTimer();
        } else {
            updateCompleted();
        }
    }

    public function cancel():void {
        _isCancelled = true;
        stopLevelUpdateTimer();
        resetUpdateProcess();
    }

    private function resetUpdateProcess():void {
        if (_outdatedLevels) {
            _outdatedLevels.length = 0;
        }
        _updatedLevelCount = 0;
        _levelIndexToUpdate = 0;
        _isInProcess = false;
    }

    private function getOutdatedLevels():Vector.<SLTLevel> {
        var levelsToUpdate:Vector.<SLTLevel> = new <SLTLevel>[];
        for (var i:int = 0, length:int = _allLevels.length; i < length; ++i) {
            var currentLevel:SLTLevel = _allLevels[i];
            if (!_levelContentLoader.cachedLevelFileExists(_levelCollectionFeatureToken, currentLevel)) {
                levelsToUpdate.push(currentLevel);
            }
        }
        return levelsToUpdate;
    }

    private function startLevelUpdateTimer():void {
        stopLevelUpdateTimer();
        _levelUpdateTimer = new Timer(LEVEL_UPDATE_TIMER_DELAY);
        _levelUpdateTimer.addEventListener(TimerEvent.TIMER, levelUpdateTimerHandler);
        _levelUpdateTimer.start();
    }

    private function stopLevelUpdateTimer():void {
        if (null != _levelUpdateTimer) {
            _levelUpdateTimer.stop();
            _levelUpdateTimer.removeEventListener(TimerEvent.TIMER, levelUpdateTimerHandler);
            _levelUpdateTimer = null;
        }
    }

    private function levelUpdateTimerHandler(event:TimerEvent):void {
        startNextLevelsUpdate();
        if (_levelIndexToUpdate == _outdatedLevels.length) {
            stopLevelUpdateTimer();
        }
    }

    private function startNextLevelsUpdate():void {
        for (var i:uint = 0; i < DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT; ++i) {
            if (_levelIndexToUpdate < _outdatedLevels.length) {
                _levelContentLoader.loadLevelContentFromSaltr(_levelCollectionFeatureToken, _outdatedLevels[_levelIndexToUpdate], loadLevelSuccessHandler, loadLevelFailHandler);
                ++_levelIndexToUpdate;
            } else {
                return;
            }
        }
    }

    private function loadLevelSuccessHandler(featureToken:String, sltLevel:SLTLevel, data:Object):void {
        if (_isCancelled) {
            return;
        }
        _levelContentLoader.cacheLevelContent(featureToken, sltLevel, data);
        manageUpdateProcess();
    }

    private function loadLevelFailHandler(featureToken:String, sltLevel:SLTLevel, status:SLTStatus):void {
        if (_isCancelled) {
            return;
        }
        manageUpdateProcess();
    }

    private function manageUpdateProcess():void {
        ++_updatedLevelCount;
        if (_updatedLevelCount >= _outdatedLevels.length) {
            updateCompleted();
        }
    }

    private function updateCompleted():void {
        var updatedLevelCount:uint = _updatedLevelCount;
        resetUpdateProcess();
        SLTLogger.getInstance().log("Game levels group update completed. featureToken: " + _levelCollectionFeatureToken + ", updated level count: " + updatedLevelCount);
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
