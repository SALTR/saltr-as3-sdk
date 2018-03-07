/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.events.Event;

import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.factory.SLTMobileApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;
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
        _repositoryStorageManager = new SLTRepositoryStorageManager(new SLTMobileRepository());
    }

    /**
     * The repository.
     */
    public function set repository(value:SLTMobileRepository):void {
        _repositoryStorageManager = new SLTRepositoryStorageManager(value);
    }

    /**
     * Defines the local content root.
     * @param contentRoot The content root url.
     */
    public function setLocalContentRoot(contentRoot:String):void {
        _repositoryStorageManager.setLocalContentRoot(contentRoot);
    }

    /**
     * Starts the instance.
     */
    override public function start():void {
        if (_deviceId == null) {
            throw new Error("deviceId field is required and can't be null.");
        }
        _repositoryStorageManager.cleanupOldAppCache();
        _appData.initDefaultFeatures(getAppDataFromApplication());
        var cachedData:Object = getCachedAppData();
        if (cachedData == null) {
            _appData.initEmpty();
        } else {
            _appData.initWithData(cachedData);
        }

        _started = true;
    }

    private function getCachedAppData():Object {
        return _repositoryStorageManager.getAppDataFromCache();
    }

    private function getAppDataFromApplication():Object {
        return _repositoryStorageManager.getAppDataFromApplication();
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
    override protected function initLevelContentLocally(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        var defaultLevelVersion:String = _appData.getDefaultGameLevels(levelCollectionToken)[sltLevel.globalIndex].version;
        if (defaultLevelVersion == sltLevel.version) {
            initLevelContentFromSnapshot(levelCollectionToken, sltLevel, callback);
        } else if (cachedLevelUpToDate(levelCollectionToken, sltLevel)) {
            initLevelContentFromCache(levelCollectionToken, sltLevel, callback);
        } else {
            var repositoryStorageManager:SLTRepositoryStorageManager = new SLTRepositoryStorageManager(new SLTMobileRepository());
            var levelCollectionUpdater:SLTMobileLevelCollectionUpdater = new SLTMobileLevelCollectionUpdater(levelCollectionToken, new <SLTLevel>[sltLevel], repositoryStorageManager, _nativeTimeout, _dropTimeout, _timeoutIncrease);
            levelCollectionUpdater.addEventListener(Event.COMPLETE, updateCompletedHandler);

            function updateCompletedHandler(event:Event):void {
                if (_repositoryStorageManager.cachedLevelFileExists(levelCollectionToken, sltLevel.globalIndex, sltLevel.version)) {
                    initLevelContentFromCache(levelCollectionToken, sltLevel, callback);
                } else {
                    initLevelContentFromSnapshot(levelCollectionToken, sltLevel, callback);
                }
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

    private function loadLevelContentInternally(levelCollectionToken:String, level:SLTLevel):Object {
        var content:Object = null;
        var globalIndex:int = level.globalIndex;
        if (level.version == _appData.getDefaultGameLevels(levelCollectionToken)[globalIndex].version) {
            loadLevelContentFromSnapshot(levelCollectionToken, level);
        } else {
            content = loadLevelContentFromCache(levelCollectionToken, level);
        }
        return content;
    }

    private function loadLevelContentFromCache(levelCollectionToken:String, level:SLTLevel):Object {
        return _repositoryStorageManager.getLevelFromCache(levelCollectionToken, level.globalIndex, level.version);
        //  return _repositoryStorageManager.getLastModifiedLevelFromCache(levelCollectionToken, level.globalIndex);
    }

    private function loadLevelContentFromSnapshot(levelCollectionToken:String, level:SLTLevel):Object {
        var applicationLevelPath:String = _appData.getDefaultGameLevels(levelCollectionToken)[level.globalIndex].contentUrl;
        return _repositoryStorageManager.getLevelFromApplication(applicationLevelPath);
    }

    private function cachedLevelUpToDate(levelCollectionToken:String, sltLevel:SLTLevel):Boolean {
        return _repositoryStorageManager.cachedLevelFileExists(levelCollectionToken, sltLevel.globalIndex, sltLevel.version);
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

        var levelCollectionToken:String = data.levelCollectionToken;
        var sltLevel:SLTLevel = data.sltLevel;
        var callback:Function = data.callback;
        if (_repositoryStorageManager.cachedLevelFileExists(levelCollectionToken, sltLevel.globalIndex, sltLevel.version)) {
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