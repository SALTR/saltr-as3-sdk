/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.api.call.SLTApiCallFactory;
import saltr.api.call.SLTApiCallLevelContentResult;
import saltr.game.SLTLevel;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTMobileLevelGroupUpdater implements ISLTMobileLevelUpdater {
    saltr_internal static const LEVEL_UPDATE_TIMER_DELAY:Number = 3000;
    private static const DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT:uint = 3;

    private var _featureToken:String;
    private var _outdatedLevels:Vector.<SLTLevel>;
    private var _updatedLevelCount:uint;
    private var _levelIndexToUpdate:int;
    private var _levelUpdateTimer:Timer;
    private var _allLevels:Vector.<SLTLevel>;
    private var _levelContentLoader:SLTMobileLevelContentLoader;
    private var _isInProcess:Boolean;

    public function SLTMobileLevelGroupUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiCallFactory, requestIdleTimeout:int) {
        _levelContentLoader = new SLTMobileLevelContentLoader(repositoryStorageManager, apiFactory, requestIdleTimeout);
        _levelContentLoader.callback = processLevelContentLoaded;
        _outdatedLevels = new Vector.<SLTLevel>();
        resetUpdateProcess();
    }

    public function init(featureToken:String, allLevels:Vector.<SLTLevel>):void {
        _featureToken = featureToken;
        _allLevels = allLevels;
        _outdatedLevels = getOutdatedLevels();
    }

    public function update():void {
        if (_isInProcess) {
            SLTLogger.getInstance().log("SLTMobileLevelGroupUpdater.update() called. _featureToken: " + _featureToken + ", not executed _isInProcess = true");
            return;
        }
        SLTLogger.getInstance().log("SLTMobileLevelGroupUpdater.update() called. _featureToken: " + _featureToken + ", _outdatedLevels.length: " + _outdatedLevels.length);
        if (_outdatedLevels.length > 0) {
            _levelIndexToUpdate = 0;
            _isInProcess = true;
            startNextLevelsUpdate();
            startLevelUpdateTimer();
        }
    }

    public function updateCompleted():Boolean {
        return !_isInProcess;
    }

    private function resetUpdateProcess():void {
        _outdatedLevels.length = 0;
        _updatedLevelCount = 0;
        _levelIndexToUpdate = 0;
        _isInProcess = false;
    }

    private function getOutdatedLevels():Vector.<SLTLevel> {
        var levelsToUpdate:Vector.<SLTLevel> = new Vector.<SLTLevel>();
        for (var i:int = 0; i < _allLevels.length; ++i) {
            var currentLevel:SLTLevel = _allLevels[i];
            if (currentLevel.version != getCachedLevelVersion(currentLevel)) {
                levelsToUpdate.push(currentLevel);
            }
        }
        return levelsToUpdate;
    }

    private function getCachedLevelVersion(level:SLTLevel):String {
        return _levelContentLoader.getCachedLevelVersion(_featureToken, level);
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
                _levelContentLoader.loadLevelContentFromSaltr(_featureToken, _outdatedLevels[_levelIndexToUpdate]);
                ++_levelIndexToUpdate;
            } else {
                return;
            }
        }
    }

    private function processLevelContentLoaded(result:SLTApiCallLevelContentResult):void {
        var content:Object = result.data;
        if (result.success) {
            _levelContentLoader.cacheLevelContent(result.featureToken, result.level, content);
        }
        ++_updatedLevelCount;
        if (_updatedLevelCount >= _outdatedLevels.length) {
            resetUpdateProcess();
            SLTLogger.getInstance().log("SLTMobileLevelGroupUpdater _featureToken: " + _featureToken + ", updateCompleted = " + updateCompleted());
        }
    }
}
}
