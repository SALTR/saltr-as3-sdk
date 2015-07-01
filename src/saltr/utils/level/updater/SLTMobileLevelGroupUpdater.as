/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.api.SLTApiCall;
import saltr.api.SLTApiCallResult;
import saltr.api.SLTApiFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;

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

    public function SLTMobileLevelGroupUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiFactory, requestIdleTimeout:int) {
        super(repositoryStorageManager, apiFactory, requestIdleTimeout);
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
            return;
        }
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
        _levelIndexToUpdate = -1;
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
            levelContentUrl: sltLevel.contentUrl + "?_time_=" + new Date().getTime()
        };
        var levelContentApiCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_LEVEL_CONTENT, true);
        levelContentApiCall.call(params, levelContentApiCallback, _requestIdleTimeout);

        function levelContentApiCallback(result:SLTApiCallResult):void {
            var content:Object = result.data;
            if (result.success) {
                cacheLevelContent(sltLevel, content);
            }
            ++_updatedLevelCount;
            if (_updatedLevelCount >= _outdatedLevels.length) {
                resetUpdateProcess();
            }
        }
    }

    private function cacheLevelContent(level:SLTLevel, content:Object):void {
        _repositoryStorageManager.cacheLevelContent(_featureToken, level.globalIndex, level.version, content);
    }
}
}
