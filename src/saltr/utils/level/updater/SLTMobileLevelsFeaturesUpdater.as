/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import saltr.SLTFeature;
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
    private var _nativeTimeout:int;
    private var _dropTimeout:int;
    private var _timeoutIncrease:int;
    private var _levelCollectionUpdaters:Vector.<SLTMobileLevelCollectionUpdater>;
    private var _isInProcess:Boolean;
    private var _updatedGroupCount:uint;

    public function SLTMobileLevelsFeaturesUpdater(repositoryStorageManager:SLTRepositoryStorageManager, nativeTimeout:int) {
        _repositoryStorageManager = repositoryStorageManager;
        _nativeTimeout = nativeTimeout;
        _levelCollectionUpdaters = new <SLTMobileLevelCollectionUpdater>[];
        resetUpdateProcess();
    }

    public function set repositoryStorageManager(value:SLTRepositoryStorageManager):void {
        _repositoryStorageManager = value;
    }

    public function set nativeTimeout(value:int):void {
        _nativeTimeout = value;
    }

    public function set dropTimeout(value:int):void {
        _dropTimeout = value;
    }

    public function set timeoutIncrease(value:int):void {
        _timeoutIncrease = value;
    }

    public function update(levelCollections:Dictionary):void {
        SLTLogger.getInstance().log("Game level features update called.");
        if (_isInProcess) {
            cancel();
        }
        initCollectionUpdaters(levelCollections);
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
        if (_levelCollectionUpdaters.length > 0) {
            _isInProcess = true;
            for (var i:int = 0, length:int = _levelCollectionUpdaters.length; i < length; ++i) {
                _levelCollectionUpdaters[i].addEventListener(Event.COMPLETE, groupUpdatedHandler);
                _levelCollectionUpdaters[i].update();
            }
        }
    }

    private function initCollectionUpdaters(levelCollections:Dictionary):void {
        for (var key:Object in levelCollections) {
            var collection:SLTFeature = levelCollections[key];
            var collectionUpdater:SLTMobileLevelCollectionUpdater = new SLTMobileLevelCollectionUpdater(collection.token, collection.properties.allLevels, _repositoryStorageManager, _nativeTimeout, _dropTimeout, _timeoutIncrease);
            _levelCollectionUpdaters.push(collectionUpdater);
        }
        SLTLogger.getInstance().log("Game level features initialized with game levels features. Level group count to update: " + _levelCollectionUpdaters.length);
    }

    private function initWithLevel(featureToken:String, level:SLTLevel):void {
        var levels:Vector.<SLTLevel> = new <SLTLevel>[];
        levels.push(level);
        var groupUpdater:SLTMobileLevelCollectionUpdater = new SLTMobileLevelCollectionUpdater(featureToken, levels, _repositoryStorageManager, _nativeTimeout, _dropTimeout, _timeoutIncrease);
        _levelCollectionUpdaters.push(groupUpdater);
        SLTLogger.getInstance().log("Game level features initialized with dedicated level.");
    }

    private function cancel():void {
        for (var i:int = 0, length:int = _levelCollectionUpdaters.length; i < length; ++i) {
            _levelCollectionUpdaters[i].cancel();
        }
        resetUpdateProcess();
        SLTLogger.getInstance().log("Game level features previous update cancelled.");
    }

    private function resetUpdateProcess():void {
        for (var i:int = 0, length:int = _levelCollectionUpdaters.length; i < length; ++i) {
            _levelCollectionUpdaters[i].removeEventListener(Event.COMPLETE, groupUpdatedHandler)
        }
        _levelCollectionUpdaters.length = 0;
        _updatedGroupCount = 0;
        _isInProcess = false;
    }

    private function groupUpdatedHandler(event:Event):void {
        ++_updatedGroupCount;
        SLTLogger.getInstance().log("Game level features one group update completed. TotalGroupCount: " + _levelCollectionUpdaters.length + " UpdatedGroupCount: " + _updatedGroupCount);
        if (_levelCollectionUpdaters.length == _updatedGroupCount) {
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
