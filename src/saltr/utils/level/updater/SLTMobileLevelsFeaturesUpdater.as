/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;

import saltr.SLTFeature;
import saltr.api.SLTApiFactory;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTMobileLevelsFeaturesUpdater extends SLTMobileLevelUpdater implements ISLTMobileLevelUpdater {
    private var _gameLevelGroups:Vector.<SLTMobileLevelGroupUpdater>;
    private var _levelUpdateTimer:Timer;

    public function SLTMobileLevelsFeaturesUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiFactory, requestIdleTimeout:int) {
        super(repositoryStorageManager, apiFactory, requestIdleTimeout);
        _gameLevelGroups = new Vector.<SLTMobileLevelGroupUpdater>();
        resetUpdateProcess();
    }

    public function init(gameLevelsFeatures:Dictionary):void {
        for (var key:Object in gameLevelsFeatures) {
            var feature:SLTFeature = gameLevelsFeatures[key];
            var groupUpdater:SLTMobileLevelGroupUpdater = new SLTMobileLevelGroupUpdater(_repositoryStorageManager, _apiFactory, _requestIdleTimeout);
            groupUpdater.init(feature.token, feature.properties.allLevels);
            _gameLevelGroups.push(groupUpdater);
        }
    }

    public function update():void {
        if (_isInProcess) {
            return;
        }
        _isInProcess = true;
        for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
            _gameLevelGroups[i].update();
        }
        startLevelUpdateTimer();
    }

    public function updateCompleted():Boolean {
        return _isInProcess;
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
        var updateCompleted:Boolean = true;
        for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
            if (false == _gameLevelGroups[i].updateCompleted()) {
                updateCompleted = false;
                break;
            }
        }

        if (updateCompleted) {
            stopLevelUpdateTimer();
            _isInProcess = false;
        }
    }
}
}
