/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import saltr.SLTFeature;
import saltr.api.call.SLTApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTMobileLevelsFeaturesUpdater extends EventDispatcher {
    private var _repositoryStorageManager:SLTRepositoryStorageManager;
    private var _apiFactory:SLTApiCallFactory;
    private var _requestIdleTimeout:int;
    private var _gameLevelGroups:Vector.<SLTMobileLevelGroupUpdater>;
    private var _isInProcess:Boolean;
    private var _updatedGroupCount:uint;

    public function SLTMobileLevelsFeaturesUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiCallFactory, requestIdleTimeout:int) {
        _repositoryStorageManager = repositoryStorageManager;
        _apiFactory = apiFactory;
        _requestIdleTimeout = requestIdleTimeout;
        _gameLevelGroups = new Vector.<SLTMobileLevelGroupUpdater>();
        resetUpdateProcess();
    }

    public function set apiFactory(value:SLTApiCallFactory):void {
        _apiFactory = value;
    }

    public function set repositoryStorageManager(value:SLTRepositoryStorageManager):void {
        _repositoryStorageManager = value;
    }

    public function set requestIdleTimeout(value:int):void {
        _requestIdleTimeout = value;
    }

    public function update(gameLevelsFeatures:Dictionary):void {
        SLTLogger.getInstance().log("Game level features update called.");
        if (_isInProcess) {
            cancel();
        }
        initWithFeatures(gameLevelsFeatures);
        startUpdate();
    }

    public function updateLevel(gameLevelsFeatureToken:String, level:SLTLevel):void {
        SLTLogger.getInstance().log("Update dedicated game level called.");
        if (_isInProcess) {
            cancel();
        }
        initWithLevel(gameLevelsFeatureToken, level);
        startUpdate();
    }

    private function startUpdate():void {
        SLTLogger.getInstance().log("Game level features update started.");
        if (_gameLevelGroups.length > 0) {
            _isInProcess = true;
            for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
                _gameLevelGroups[i].addEventListener(Event.COMPLETE, groupUpdatedHandler);
                _gameLevelGroups[i].update();
            }
        }
    }

    private function initWithFeatures(gameLevelsFeatures:Dictionary):void {
        for (var key:Object in gameLevelsFeatures) {
            var feature:SLTFeature = gameLevelsFeatures[key];
            var groupUpdater:SLTMobileLevelGroupUpdater = new SLTMobileLevelGroupUpdater(_repositoryStorageManager, _apiFactory, _requestIdleTimeout, feature.token, feature.properties.allLevels);
            _gameLevelGroups.push(groupUpdater);
        }
        SLTLogger.getInstance().log("Game level features initialized with game levels features. Level group count to update: " + _gameLevelGroups.length);
    }

    private function initWithLevel(featureToken:String, level:SLTLevel):void {
        var levels:Vector.<SLTLevel> = new Vector.<SLTLevel>();
        levels.push(level);
        var groupUpdater:SLTMobileLevelGroupUpdater = new SLTMobileLevelGroupUpdater(_repositoryStorageManager, _apiFactory, _requestIdleTimeout, featureToken, levels);
        _gameLevelGroups.push(groupUpdater);
        SLTLogger.getInstance().log("Game level features initialized with dedicated level.");
    }

    private function cancel():void {
        for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
            _gameLevelGroups[i].cancel();
        }
        resetUpdateProcess();
        SLTLogger.getInstance().log("Game level features previews update cancelled.");
    }

    private function resetUpdateProcess():void {
        for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
            _gameLevelGroups[i].removeEventListener(Event.COMPLETE, groupUpdatedHandler)
        }
        _gameLevelGroups.length = 0;
        _updatedGroupCount = 0;
        _isInProcess = false;
    }

    private function groupUpdatedHandler(event:Event):void {
        ++_updatedGroupCount;
        SLTLogger.getInstance().log("Game level features one group update completed. TotalGroupCount: " + _gameLevelGroups.length + " UpdatedGroupCount: " + _updatedGroupCount);
        if (_gameLevelGroups.length == _updatedGroupCount) {
            updateCompleted();
        }
    }

    private function updateCompleted():void {
        resetUpdateProcess();
        SLTLogger.getInstance().log("Game levels update completed.");
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
