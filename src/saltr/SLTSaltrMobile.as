/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.events.Event;

import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.factory.SLTMobileApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.utils.SLTMobileDeviceInfo;
import saltr.utils.level.updater.SLTMobileLevelCollectionUpdater;

use namespace saltr_internal;

/**
 * The SLTSaltrMobile class represents the entry point of mobile SDK.
 */
public class SLTSaltrMobile extends SLTSaltr {

    private var _repositoryStorageManager:SLTRepositoryStorageManager;

    /**
     * Class constructor.
     * @param clientKey The client key.
     * @param deviceId The device unique identifier.
     */
    public function SLTSaltrMobile(clientKey:String, deviceId:String) {
        super(clientKey, deviceId);
        _isWaitingForAppData = false;

        SLTApiCallFactory.factory = new SLTMobileApiCallFactory();
        _repositoryStorageManager = SLTRepositoryStorageManager.getInstance();
    }

    /**
     * Starts the instance.
     */
    override public function start():void {
        if (_deviceId == null) {
            throw new Error("deviceId field is required and can't be null.");
        }

        //TODO: this line should be called only on 1st game run, if not possible - delete
        //_repositoryStorageManager.cleanupOldAppCache();

        _appData.initFeatures(getAppDataFromSnapshot());
        var cachedAppData:Object = getCachedAppData();

        if (cachedAppData != null) {
            _appData.initWithData(cachedAppData);
        }

        _started = true;
    }

    private function getCachedAppData():Object {
        return _repositoryStorageManager.getAppDataFromCache();
    }

    private function getAppDataFromSnapshot():Object {
        return _repositoryStorageManager.getAppDataFromSnapshot();
    }

    override protected function updateMissingProperties(basicProperties:SLTBasicProperties):void {
        var deviceInfo:Object;
        if (!basicProperties.systemName || !basicProperties.systemVersion || !basicProperties.deviceType) {
            deviceInfo = SLTMobileDeviceInfo.getDeviceInfo();
        }
        if (!basicProperties.systemName) {
            basicProperties.systemName = deviceInfo.osName;
        }
        if (!basicProperties.deviceType) {
            basicProperties.deviceType = deviceInfo.deviceType;
        }
        if (!basicProperties.systemVersion) {
            basicProperties.systemVersion = deviceInfo.version;
        }
    }

    /**
     * Initialize level content.
     * @param levelCollectionToken The Level Collection feature token
     * @param sltLevel The level.
     * @param callback
     */
    override protected function initLevelContentFromAvailableSource(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        if (sltLevel.defaultVersion == sltLevel.version) {
            initLevelContentFromSnapshot(levelCollectionToken, sltLevel, callback);
        } else if (isLevelContentCacheAvailable(levelCollectionToken, sltLevel)) {
            initLevelContentFromCache(levelCollectionToken, sltLevel, callback);
        } else {
            var levelCollectionUpdater:SLTMobileLevelCollectionUpdater = new SLTMobileLevelCollectionUpdater(levelCollectionToken, new <SLTLevel>[sltLevel], _nativeTimeout, _dropTimeout, _timeoutIncrease);
            levelCollectionUpdater.addEventListener(Event.COMPLETE, updateCompletedHandler);

            function updateCompletedHandler(event:Event):void {
                initLevelFromCacheOrSnapshot(levelCollectionToken, sltLevel, callback);
            }

            levelCollectionUpdater.update();
        }
    }

    /**
     * Initialize level content with latest data from saltr.
     * @param levelCollectionToken The Level Collection feature token
     * @param sltLevel The level.
     * @param callback The callback function. Called when level initialization completed.
     */
    override protected function initLevelContentFromSaltr(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        var additionalCallParams:Object = {
            levelCollectionToken: levelCollectionToken,
            sltLevel: sltLevel,
            callback: callback
        };

        if (canGetAppData()) {
            additionalCallParams.context = SLTContext.FORCED;
            getAppData(appDataInitLevelSuccessHandler, null, false, null, null, additionalCallParams);
        } else {
            appDataInitLevelSuccessHandler(additionalCallParams);
        }
    }

    private function loadLevelContentFromCache(levelCollectionToken:String, level:SLTLevel):Object {
        return _repositoryStorageManager.getLevelContentFromCache(levelCollectionToken, level.globalIndex, level.version);
        //  return _repositoryStorageManager.getLastModifiedLevelFromCache(levelCollectionToken, level.globalIndex);
    }

    private function loadLevelContentFromSnapshot(levelCollectionToken:String, level:SLTLevel):Object {
        return _repositoryStorageManager.getLevelContentFromSnapshot(level.defaultContentUrl);
    }

    private function isLevelContentCacheAvailable(levelCollectionToken:String, sltLevel:SLTLevel):Boolean {
        return _repositoryStorageManager.isCachedLevelContentFileExists(levelCollectionToken, sltLevel.globalIndex, sltLevel.version);
    }

    private function updateSLTLevelContent(content:Object, sltLevel:SLTLevel, callback:Function):void {
        if (content == null) {
            throw new Error("[initLevelContentLocally] Level with globalIndex = " + sltLevel.globalIndex + " is missing in  game feature");
        }
        else {
            sltLevel.updateContent(content);
        }
        callback(true);
    }

    private function appDataInitLevelSuccessHandler(data:Object):void {
        _isWaitingForAppData = false;

        initLevelFromCacheOrSnapshot(data.levelCollectionToken, data.sltLevel, data.callback);
    }

    private function initLevelFromCacheOrSnapshot(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        if (_repositoryStorageManager.isCachedLevelContentFileExists(levelCollectionToken, sltLevel.globalIndex, sltLevel.version)) {
            initLevelContentFromCache(levelCollectionToken, sltLevel, callback);
        } else {
            initLevelContentFromSnapshot(levelCollectionToken, sltLevel, callback);
        }
    }

    private function initLevelContentFromSnapshot(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        var content:Object = loadLevelContentFromSnapshot(levelCollectionToken, sltLevel);
        updateSLTLevelContent(content, sltLevel, callback);
    }

    private function initLevelContentFromCache(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        var content:Object = loadLevelContentFromCache(levelCollectionToken, sltLevel);
        updateSLTLevelContent(content, sltLevel, callback);
    }
}
}