/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.events.Event;

import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.factory.SLTMobileApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.ISLTRepository;
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
     * @param flashStage The flash stage.
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
    public function set repository(value:ISLTRepository):void {
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
     * @param gameLevelsFeatureToken The "GameLevels" feature token
     * @param sltLevel The level.
     * @return TRUE if success, FALSE otherwise.
     */
    override protected function initLevelContentLocally(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        var defaultLevelVersion:String = _appData.getDefaultGameLevels(gameLevelsFeatureToken)[sltLevel.globalIndex].version;
        if(defaultLevelVersion == sltLevel.version) {
            initLevelContentFromSnapshot(gameLevelsFeatureToken, sltLevel, callback);
        } else if (cachedLevelUpToDate(gameLevelsFeatureToken, sltLevel)) {
            initLevelContentFromCache(gameLevelsFeatureToken, sltLevel, callback);
        } else {
            var repositoryStorageManager:SLTRepositoryStorageManager = new SLTRepositoryStorageManager(new SLTMobileRepository());
            var levelCollectionUpdater:SLTMobileLevelCollectionUpdater = new SLTMobileLevelCollectionUpdater(gameLevelsFeatureToken, new <SLTLevel>[sltLevel], repositoryStorageManager, _nativeTimeout, _dropTimeout, _timeoutIncrease);
            levelCollectionUpdater.addEventListener(Event.COMPLETE, updateCompletedHandler);
            function updateCompletedHandler(event:Event):void {
                if (_repositoryStorageManager.cachedLevelFileExist(gameLevelsFeatureToken, sltLevel.globalIndex, sltLevel.version)) {
                    initLevelContentFromCache(gameLevelsFeatureToken, sltLevel, callback);
                } else {
                    initLevelContentFromSnapshot(gameLevelsFeatureToken, sltLevel, callback);
                }
            }
            levelCollectionUpdater.update();
        }
    }

    /**
     * Initialize level content with latest data from saltr.
     * @param gameLevelsFeatureToken The "GameLevels" feature token
     * @param sltLevel The level.
     * @param callback The callback function. Called when level initialization completed.
     */
    override protected function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        var additionalCallParams:Object = {
            gameLevelsFeatureToken: gameLevelsFeatureToken,
            sltLevel: sltLevel,
            callback: callback
        };

        if (canGetAppData()) {
            additionalCallParams.context = "secondary";
            getAppData(appDataInitLevelSuccessHandler, null, false, null, null, additionalCallParams);
        } else {
            appDataInitLevelSuccessHandler(additionalCallParams);
        }
    }

    private function loadLevelContentInternally(gameLevelsFeatureToken:String, level:SLTLevel):Object {
        var content:Object = null;
        var globalIndex:int = level.globalIndex;
        if (level.version == _appData.getDefaultGameLevels(gameLevelsFeatureToken)[globalIndex].version) {
            loadLevelContentFromSnapshot(gameLevelsFeatureToken, level);
        } else {
            content = loadLevelContentFromCache(gameLevelsFeatureToken, level);
        }
        return content;
    }

    private function loadLevelContentFromCache(gameLevelsFeatureToken:String, level:SLTLevel):Object {
        return _repositoryStorageManager.getLevelFromCache(gameLevelsFeatureToken, level.globalIndex, level.version);
        //  return _repositoryStorageManager.getLastModifiedLevelFromCache(gameLevelsFeatureToken, level.globalIndex);
    }

    private function loadLevelContentFromSnapshot(gameLevelsFeatureToken:String, level:SLTLevel):Object {
        var applicationLevelPath:String = _appData.getDefaultGameLevels(gameLevelsFeatureToken)[level.globalIndex].contentUrl;
        return _repositoryStorageManager.getLevelFromApplication(applicationLevelPath);
    }

    private function cachedLevelUpToDate(gameLevelsFeatureToken:String, sltLevel:SLTLevel):Boolean {
        var repositoryStorageManager:SLTRepositoryStorageManager = new SLTRepositoryStorageManager(new SLTMobileRepository());
        return repositoryStorageManager.cachedLevelFileExist(gameLevelsFeatureToken, sltLevel.globalIndex, sltLevel.version);
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

        var gameLevelsFeatureToken:String = data.gameLevelsFeatureToken;
        var sltLevel:SLTLevel = data.sltLevel;
        var callback:Function = data.callback;
        initLevelContentFromCache(gameLevelsFeatureToken, sltLevel, callback);
    }

    private function initLevelContentFromSnapshot(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        var content:Object = loadLevelContentFromSnapshot(gameLevelsFeatureToken, sltLevel);
        updateSLTLevelContent(content, sltLevel, callback);
    }

    private function initLevelContentFromCache(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        var content:Object = loadLevelContentFromCache(gameLevelsFeatureToken, sltLevel);
        updateSLTLevelContent(content, sltLevel, callback);
    }
}
}