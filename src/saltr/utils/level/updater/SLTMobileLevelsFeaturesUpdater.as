/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import saltr.SLTFeature;
import saltr.api.call.SLTApiCallFactory;
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
        SLTLogger.getInstance().log("SLTMobileLevelsFeaturesUpdater.SLTMobile() called. _gameLevelGroups.length: " + _gameLevelGroups.length);
        _isInProcess = true;
        for (var i:int = 0; i < _gameLevelGroups.length; ++i) {
            _gameLevelGroups[i].update();
            _gameLevelGroups[i].addEventListener(Event.COMPLETE, groupUpdatedHandler)
        }
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
        if (_gameLevelGroups.length == _updatedGroupCount) {
            resetUpdateProcess();
            SLTLogger.getInstance().log("SLTMobileLevelsFeaturesUpdater updateCompleted.");
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }
}
}
