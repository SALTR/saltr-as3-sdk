/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallFactory;
import saltr.api.call.SLTApiCallLevelContentResult;
import saltr.api.handler.SLTLevelContentApiCallHandler;
import saltr.game.SLTLevel;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTMobileLevelGroupUpdater extends SLTMobileLevelUpdater implements ISLTMobileLevelUpdater {
    private var _featureToken:String;
    private var _outdatedLevels:Vector.<SLTLevel>;
    private var _updatedLevelCount:uint;
    private var _levelIndexToUpdate:int;
    private var _levelUpdateTimer:Timer;
    private var _allLevels:Vector.<SLTLevel>;

    private var _levelContentHandler:SLTLevelContentApiCallHandler;

    public function SLTMobileLevelGroupUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiCallFactory, requestIdleTimeout:int) {
        super(repositoryStorageManager, apiFactory, requestIdleTimeout);
        _outdatedLevels = new Vector.<SLTLevel>();
        resetUpdateProcess();
        initApiCallHandlers();
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

    override protected function resetUpdateProcess():void {
        _outdatedLevels.length = 0;
        _updatedLevelCount = 0;
        _levelIndexToUpdate = 0;
        super.resetUpdateProcess();
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
        return _repositoryStorageManager.getLevelVersionFromCache(_featureToken, level.globalIndex);
    }

    private function startLevelUpdateTimer():void {
        stopLevelUpdateTimer();
        _levelUpdateTimer = new Timer(SLTMobileLevelUpdater.LEVEL_UPDATE_TIMER_DELAY);
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
                loadLevelContentFromSaltr(_outdatedLevels[_levelIndexToUpdate]);
                ++_levelIndexToUpdate;
            } else {
                return;
            }
        }
    }

    /**
     * Loads the level content.
     * @param sltLevel The level.
     */
    private function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var params:Object = {
            sltLevel: sltLevel
        };
        var levelContentApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT, true);
        levelContentApiCall.call(params, _levelContentHandler, _requestIdleTimeout);
    }

    private function cacheLevelContent(level:SLTLevel, content:Object):void {
        _repositoryStorageManager.cacheLevelContent(_featureToken, level.globalIndex, level.version, content);
    }

    private function processLevelContentLoaded(result:SLTApiCallLevelContentResult):void {
        var content:Object = result.data;
        if (result.success) {
            cacheLevelContent(result.level, content);
        }
        ++_updatedLevelCount;
        if (_updatedLevelCount >= _outdatedLevels.length) {
            resetUpdateProcess();
            SLTLogger.getInstance().log("SLTMobileLevelGroupUpdater _featureToken: " + _featureToken + ", updateCompleted = " + updateCompleted());
        }
    }

    private function initApiCallHandlers():void {
        _levelContentHandler = new SLTLevelContentApiCallHandler(processLevelContentLoaded);
    }
}
}
