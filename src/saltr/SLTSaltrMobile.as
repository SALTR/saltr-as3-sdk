/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.display.Stage;

import saltr.api.AddPropertiesApiCall;
import saltr.api.ApiCall;
import saltr.api.ApiCallResult;
import saltr.api.AppDataApiCall;
import saltr.api.LevelContentApiCall;
import saltr.api.RegisterDeviceApiCall;
import saltr.api.SendLevelEndEventApiCall;
import saltr.api.SyncApiCall;
import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;
import saltr.repository.ISLTRepository;
import saltr.repository.SLTDummyRepository;
import saltr.repository.SLTMobileRepository;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataConcurrentLoadRefused;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusAppDataParseError;
import saltr.status.SLTStatusLevelContentLoadFail;
import saltr.status.SLTStatusLevelsParseError;
import saltr.utils.dialog.DialogController;
import saltr.utils.MobileDeviceInfo;
import saltr.utils.Utils;
import saltr.utils.dialog.MobileDialogController;

use namespace saltr_internal;

//TODO @GSAR: add namespaces in all packages to isolate functionality

//TODO:: @daal add some flushCache method.

/**
 * The SLTSaltrMobile class represents the entry point of mobile SDK.
 */
public class SLTSaltrMobile {
    private var _flashStage:Stage;
    private var _socialId:String;
    private var _deviceId:String;
    private var _connected:Boolean;
    private var _clientKey:String;
    private var _isLoading:Boolean;

    private var _repository:ISLTRepository;

    private var _connectSuccessCallback:Function;
    private var _connectFailCallback:Function;
    private var _levelContentLoadSuccessCallback:Function;
    private var _levelContentLoadFailCallback:Function;

    private var _requestIdleTimeout:int;
    private var _devMode:Boolean;
    private var _autoRegisterDevice:Boolean;
    private var _started:Boolean;
    private var _isSynced:Boolean;
    private var _useNoLevels:Boolean;
    private var _useNoFeatures:Boolean;
    private var _dialogController:MobileDialogController;

    private var _appData:AppData;
    private var _levelData:LevelData;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     * @param clientKey The client key.
     * @param deviceId The device unique identifier.
     * @param useCache The cache enabled state.
     */
    public function SLTSaltrMobile(flashStage:Stage, clientKey:String, deviceId:String, useCache:Boolean = true) {
        _flashStage = flashStage;
        _clientKey = clientKey;
        _deviceId = deviceId;
        _isLoading = false;
        _connected = false;
        _useNoLevels = false;
        _useNoFeatures = false;

        _devMode = false;
        _autoRegisterDevice = true;
        _started = false;
        _isSynced = false;
        _requestIdleTimeout = 0;

        _repository = useCache ? new SLTMobileRepository() : new SLTDummyRepository();
        _dialogController = new MobileDialogController(_flashStage, addDeviceToSALTR);

        _appData = new AppData();
        _levelData = new LevelData();
    }

    /**
     * The repository.
     */
    public function set repository(value:ISLTRepository):void {
        _repository = value;
    }

    /**
     * The levels using state.
     */
    public function set useNoLevels(value:Boolean):void {
        _useNoLevels = value;
    }

    /**
     * The feature using state.
     */
    public function set useNoFeatures(value:Boolean):void {
        _useNoFeatures = value;
    }

    /**
     * The dev mode state.
     */
    public function set devMode(value:Boolean):void {
        _devMode = value;
    }

    /**
     * The device automatically registration state.
     */
    public function set autoRegisterDevice(value:Boolean):void {
        _autoRegisterDevice = value;
    }

    /**
     * The request idle timeout.
     */
    public function set requestIdleTimeout(value:int):void {
        _requestIdleTimeout = value;
    }

    /**
     * The level packs.
     */
    public function get levelPacks():Vector.<SLTLevelPack> {
        return _levelData.levelPacks;
    }

    /**
     * All levels.
     */
    public function get allLevels():Vector.<SLTLevel> {
        return _levelData.allLevels;
    }

    /**
     * The total levels number.
     */
    public function get allLevelsCount():uint {
        return _levelData.allLevelsCount;
    }

    /**
     * The experiments.
     */
    public function get experiments():Vector.<SLTExperiment> {
        return _appData.experiments;
    }

    /**
     * The social identifier.
     */
    public function set socialId(socialId:String):void {
        _socialId = socialId;
    }

    /**
     * Provides the level by provided global index.
     * @param index The global index of the level.
     * @return SLTLevel The level instance specified by index.
     */
    public function getLevelByGlobalIndex(index:int):SLTLevel {
        return _levelData.getLevelByGlobalIndex(index);
    }

    /**
     * Provides the level pack by provided global index.
     * @param index The global index of the level pack.
     * @return SLTLevelPack The level pack instance specified by index.
     */
    public function getPackByLevelGlobalIndex(index:int):SLTLevelPack {
        return _levelData.getPackByLevelGlobalIndex(index);
    }

    /**
     * Provides active feature tokens.
     */
    public function getActiveFeatureTokens():Vector.<String> {
        return _appData.getActiveFeatureTokens();
    }

    /**
     * Provides the feature properties by provided token.
     * @param token The unique identifier of the feature.
     * @return Object The feature's properties.
     */
    public function getFeatureProperties(token:String):Object {
        return _appData.getFeatureProperties(token);
    }

    /**
     * Imports level from provided path.
     * @param path The path of the levels.
     */
    public function importLevels(path:String = null):void {
        if (_useNoLevels) {
            return;
        }

        if (!_started) {
            path = path == null ? SLTConfig.LOCAL_LEVELPACK_PACKAGE_URL : path;
            var applicationData:Object = _repository.getObjectFromApplication(path);
            _levelData.initWithData(applicationData);
        } else {
            throw new Error("Method 'importLevels()' should be called before 'start()' only.");
        }
    }

    /**
     * Define feature.
     * @param token The unique identifier of the feature.
     * @param properties The properties of the feature.
     * @param required The required state of the feature.
     */
    public function defineFeature(token:String, properties:Object, required:Boolean = false):void {
        if (_useNoFeatures) {
            return;
        }

        if (_started == false) {
            _appData.defineFeature(token, properties, required);
        } else {
            throw new Error("Method 'defineFeature()' should be called before 'start()' only.");
        }
    }

    /**
     * Starts the instance.
     */
    public function start():void {
        if (_deviceId == null) {
            throw new Error("deviceId field is required and can't be null.");
        }

        if (Utils.getDictionarySize(_appData.developerFeatures) == 0 && _useNoFeatures == false) {
            throw new Error("Features should be defined.");
        }

        if (_levelData.levelPacks.length == 0 && _useNoLevels == false) {
            throw new Error("Levels should be imported.");
        }

        var cachedData:Object = _repository.getObjectFromCache(SLTConfig.APP_DATA_URL_CACHE);
        if (cachedData == null) {
            _appData.initEmpty();
        } else {
            _appData.initWithData(cachedData);
        }

        _started = true;
    }

    /**
     * Establishes the connection to Saltr server.
     */
    public function connect(successCallback:Function, failCallback:Function, basicProperties:Object = null, customProperties:Object = null):void {
        if (!_started) {
            throw new Error("Method 'connect()' should be called after 'start()' only.");
        }

        if (_isLoading) {
            failCallback(new SLTStatusAppDataConcurrentLoadRefused());
            return;
        }

        _connectSuccessCallback = successCallback;
        _connectFailCallback = failCallback;

        _isLoading = true;

        var params:Object = {
            clientKey: _clientKey,
            deviceId: _deviceId,
            devMode: _devMode,
            socialId: _socialId,
            basicProperties: basicProperties,
            customProperties: customProperties
        };
        var appDataCall:AppDataApiCall = new AppDataApiCall(params);
        appDataCall.call(appDataApiCallback, _requestIdleTimeout);
    }

    /**
     * Loads the level content.
     * @param sltLevel The level.
     * @param successCallback The success callback function.
     * @param failCallback The fail callback function.
     * @param useCache The cache enabled state.
     */
    public function loadLevelContent(sltLevel:SLTLevel, successCallback:Function, failCallback:Function, useCache:Boolean = true):void {
        _levelContentLoadSuccessCallback = successCallback;
        _levelContentLoadFailCallback = failCallback;
        var content:Object = null;
        if (_connected == false) {
            if (useCache == true) {
                content = loadLevelContentInternally(sltLevel);
            } else {
                content = loadLevelContentFromDisk(sltLevel);
            }
            levelContentLoadSuccessHandler(sltLevel, content);
        } else {
            if (useCache == false || sltLevel.version != getCachedLevelVersion(sltLevel)) {
                loadLevelContentFromSaltr(sltLevel);
            } else {
                content = loadLevelContentFromCache(sltLevel);
                levelContentLoadSuccessHandler(sltLevel, content);
            }
        }
    }

    /**
     * Adds properties.
     * @param basicProperties The basic properties.
     * @param customProperties The custom properties.
     */
    public function addProperties(basicProperties:Object = null, customProperties:Object = null):void {
        if (!basicProperties && !customProperties) {
            return;
        }

        var params:Object = {
            clientKey: _clientKey,
            deviceId: _deviceId,
            socialId: _socialId,
            basicProperties: basicProperties,
            customProperties: customProperties
        };
        var addPropertiesApiCall:AddPropertiesApiCall = new AddPropertiesApiCall(params);
        addPropertiesApiCall.call(addPropertiesApiCallback, _requestIdleTimeout);
    }

    /**
     * Opens device registration dialog.
     */
    public function registerDevice():void {
        if (!_started) {
            throw new Error("Method 'registerDevice()' should be called after 'start()' only.");
        }
        _dialogController.showRegistrationDialog();
    }

    /**
     * Send "level end" event
     * @param variationId The variation identifier.
     * @param endStatus The end status.
     * @param endReason The end reason.
     * @param score The score.
     * @param customTextProperties The custom text properties.
     * @param customNumbericProperties The numberic properties.
     */
    public function sendLevelEndEvent(variationId:String, endStatus:String, endReason:String, score:int, customTextProperties:Array, customNumbericProperties:Array):void {
        var params:Object = {
            clientKey: _clientKey,
            devMode: _devMode,
            variationId: variationId,
            deviceId: _deviceId,
            socialId: _socialId,
            endReason: endReason,
            endStatus: endStatus,
            score: score,
            customNumbericProperties: customNumbericProperties,
            customTextProperties: customTextProperties
        };

        var sendLevelEndEventApiCall:SendLevelEndEventApiCall = new SendLevelEndEventApiCall(params);
        sendLevelEndEventApiCall.call(sendLevelEndApiCallback);
    }

    /**
     * Loads the level content.
     * @param sltLevel The level.
     */
    protected function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var params:Object = {
            levelContentUrl: sltLevel.contentUrl + "?_time_=" + new Date().getTime()
        };
        var levelContentApiCall:LevelContentApiCall = new LevelContentApiCall(params);
        levelContentApiCall.call(levelContentApiCallback, _requestIdleTimeout);

        function levelContentApiCallback(result:ApiCallResult):void {
            var content:Object = result.data;
            if (result.success) {
                cacheLevelContent(sltLevel, content);
            } else {
                content = loadLevelContentInternally(sltLevel);
            }
            loadInternally(sltLevel, content);
        }

        function loadInternally(sltLevel:SLTLevel, content:Object):void {
            if (content != null) {
                levelContentLoadSuccessHandler(sltLevel, content);
            }
            else {
                levelContentLoadFailHandler();
            }
        }
    }

    protected function levelContentLoadSuccessHandler(sltLevel:SLTLevel, content:Object):void {
        sltLevel.updateContent(content);
        _levelContentLoadSuccessCallback();
    }

    protected function levelContentLoadFailHandler():void {
        _levelContentLoadFailCallback(new SLTStatusLevelContentLoadFail());
    }

    private function addPropertiesApiCallback(result:ApiCallResult):void {
        if (result.success) {
            trace("[addPropertiesApiCallback] success");
        } else {
            trace("[addPropertiesApiCallback] error");
        }
    }

    private function appDataApiCallback(result:ApiCallResult):void {
        if (result.success) {
            appDataLoadSuccessCallback(result);
        } else {
            appDataLoadFailCallback(result.status);
        }
    }

    //TODO @GSAR: later we need to report the feature set differences by an event or a callback to client;
    private function appDataLoadSuccessCallback(result:ApiCallResult):void {
        _isLoading = false;

        if (_devMode && !_isSynced) {
            sync();
        }

        var levelType:String = result.data.levelType;

        try {
            _appData.initWithData(result.data);
        } catch (e:Error) {
            _connectFailCallback(new SLTStatusAppDataParseError());
            return;
        }

        if (!_useNoLevels && levelType != SLTLevel.LEVEL_TYPE_NONE) {
            try {
                _levelData.initWithData(result.data);
            } catch (e:Error) {
                _connectFailCallback(new SLTStatusLevelsParseError());
                return;
            }

        }

        _connected = true;
        _repository.cacheObject(SLTConfig.APP_DATA_URL_CACHE, "0", result.data);

        _connectSuccessCallback();

        trace("[SALTR] AppData load success. LevelPacks loaded: " + _levelData.levelPacks.length);
    }

    private function appDataLoadFailCallback(status:SLTStatus):void {
        _isLoading = false;
        if (status.statusCode == SLTStatus.API_ERROR) {
            _connectFailCallback(new SLTStatusAppDataLoadFail());
        } else {
            _connectFailCallback(status);
        }
    }

    protected function addDeviceSuccessHandler():void {
        trace("[Saltr] Dev adding new device has succeed.");
        sync();
    }

    protected function addDeviceFailHandler(result:ApiCallResult):void {
        trace("[Saltr] Dev adding new device has failed.");
        _dialogController.showRegistrationFailStatus(result.status.statusMessage);
    }

    private function addDeviceToSALTR(email:String):void {
        var params:Object = {
            email: email,
            clientKey: _clientKey,
            deviceId: _deviceId,
            deviceInfo: MobileDeviceInfo.getDeviceInfo(),
            devMode: _devMode
        };
        var apiCall:ApiCall = new RegisterDeviceApiCall(params);
        apiCall.call(registerDeviceApiCallback);
    }

    private function registerDeviceApiCallback(result:ApiCallResult):void {
        if (result.success) {
            addDeviceSuccessHandler();
        } else {
            addDeviceFailHandler(result);
        }
    }

    private function sendLevelEndApiCallback(result:ApiCallResult):void {
        if (result.success) {
            trace("sendLevelEndSuccessHandler");
        } else {
            trace("sendLevelEndFailHandler");
        }
    }

    private function sync():void {
        var params:Object = {
            clientKey: _clientKey,
            devMode: _devMode,
            deviceId: _deviceId,
            socialId: _socialId,
            developerFeatures: _appData.developerFeatures
        };
        var syncApiCall:SyncApiCall = new SyncApiCall(params);
        syncApiCall.call(syncApiCallback);
    }

    private function syncApiCallback(result:ApiCallResult):void {
        if (result.success) {
            syncSuccessHandler();
        } else {
            syncFailHandler(result);
        }
    }

    protected function syncSuccessHandler():void {
        _isSynced = true;
    }

    protected function syncFailHandler(result:ApiCallResult):void {
        if (result.status.statusCode == SLTStatus.REGISTRATION_REQUIRED_ERROR_CODE && _autoRegisterDevice) {
            registerDevice();
        }
        else {
            trace("[Saltr] Dev feature Sync has failed. " + result.status.statusMessage);
        }
    }

    private function getCachedLevelVersion(sltLevel:SLTLevel):String {
        var cachedFileName:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        return _repository.getObjectVersion(cachedFileName);
    }

    private function cacheLevelContent(sltLevel:SLTLevel, content:Object):void {
        var cachedFileName:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        _repository.cacheObject(cachedFileName, String(sltLevel.version), content);
    }

    private function loadLevelContentInternally(sltLevel:SLTLevel):Object {
        var content:Object = loadLevelContentFromCache(sltLevel);
        if (content == null) {
            content = loadLevelContentFromDisk(sltLevel);
        }
        return content;
    }

    private function loadLevelContentFromCache(sltLevel:SLTLevel):Object {
        var url:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        return _repository.getObjectFromCache(url);
    }

    private function loadLevelContentFromDisk(sltLevel:SLTLevel):Object {
        var url:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_PACKAGE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        return _repository.getObjectFromApplication(url);
    }
}
}
