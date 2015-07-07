/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;

import saltr.SLTFeature;
import saltr.api.call.SLTApiCallFactory;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTMobileLevelsFeaturesUpdater extends SLTMobileLevelUpdater implements ISLTMobileLevelUpdater {
    private var _gameLevelGroups:Vector.<SLTMobileLevelGroupUpdater>;
    private var _levelUpdateTimer:Timer;

    public function SLTMobileLevelsFeaturesUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiCallFactory, requestIdleTimeout:int) {
        super(repositoryStorageManager, apiFactory, requestIdleTimeout);
        _gameLevelGroups = new Vector.<SLTMobileLevelGroupUpdater>();
        resetUpdateProcess();
    }

    public function init(gameLevelsFeatures:Dictionary):void {
        if (_isInProcess) {
            return;
        }
        for (var key:Object in gameLevelsFeatures) {
            var feature:SLTFeature = gameLevelsFeatures[key];
            var groupUpdater:SLTMobileLevelGroupUpdater = new SLTMobileLevelGroupUpdater(_repositoryStorageManager, _apiFactory, _requestIdleTimeout);
            groupUpdater.init(feature.token, feature.properties.allLevels);
            _gameLevelGroups.push(groupUpdater);
        }
    }

    public function update():void {
        if (_isInProcess) {
            SLTLogger.getInstance().log("SLTMobileLevelsFeaturesUpdater.SLTMobile() called, not executed _isInProcess = true");
            return;
        }
        SLTLogger.getInstance().log("SLTMobileLevelsFeaturesUpdater.SLTMobile() called. _gameLevelGroups.length: "+_gameLevelGroups.length);
        _isInProcess = true;
        for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
            _gameLevelGroups[i].update();
        }
        startLevelUpdateTimer();
    }

    public function updateCompleted():Boolean {
        return _isInProcess;
    }

    override protected function resetUpdateProcess():void {
        _gameLevelGroups.length = 0;
        super.resetUpdateProcess();
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
        var isUpdated:Boolean = true;
        for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
            if (false == _gameLevelGroups[i].updateCompleted()) {
                isUpdated = false;
                break;
            }
        }

        if (isUpdated) {
            stopUpdating();
        }
    }

    private function stopUpdating():void {
        stopLevelUpdateTimer();
        resetUpdateProcess();
        SLTLogger.getInstance().log("SLTMobileLevelsFeaturesUpdater updateCompleted.");
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
