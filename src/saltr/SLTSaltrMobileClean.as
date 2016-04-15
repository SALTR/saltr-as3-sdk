/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.factory.SLTMobileApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.ISLTRepository;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.utils.SLTMobileDeviceInfo;

use namespace saltr_internal;

/**
 * The SLTSaltrMobile class represents the entry point of mobile SDK.
 */
public class SLTSaltrMobileClean extends SLTSaltr {

    private var _repositoryStorageManager:SLTRepositoryStorageManager;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     * @param clientKey The client key.
     * @param deviceId The device unique identifier.
     */
    public function SLTSaltrMobileClean(clientKey:String, deviceId:String) {
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
    override public function initLevelContentLocally(gameLevelsFeatureToken:String, sltLevel:SLTLevel):Boolean {
        var content:Object = loadLevelContentInternally(gameLevelsFeatureToken, sltLevel);
        if (null != content) {
            sltLevel.updateContent(content);
            return true;
        } else {
            return false;
        }
    }

    /**
     * Initialize level content with latest data from saltr.
     * @param gameLevelsFeatureToken The "GameLevels" feature token
     * @param sltLevel The level.
     * @param callback The callback function. Called when level initialization completed.
     */
    override public function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        if (!_started) {
            throw new Error("Method 'initLevelContentFromSaltr' should be called after 'start()' only.");
        }

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
        var content:Object = _repositoryStorageManager.getLevelFromCache(gameLevelsFeatureToken, level.globalIndex);
        if (content == null) {
            var applicationLevelPath:String = _appData.getDefaultGameLevels(gameLevelsFeatureToken)[level.globalIndex].contentUrl;
            content = _repositoryStorageManager.getLevelFromApplication(applicationLevelPath);
        }
        return content;
    }

    private function appDataInitLevelSuccessHandler(data:Object):void {
        _isWaitingForAppData = false;

        var gameLevelsFeatureToken:String = data.gameLevelsFeatureToken;
        var level:SLTLevel = data.sltLevel;
        var callback:Function = data.callback;
        var success:Boolean = initLevelContentLocally(gameLevelsFeatureToken, level);

        callback(success);
    }
}
}