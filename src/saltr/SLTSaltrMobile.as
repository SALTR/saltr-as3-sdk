/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.display.Stage;
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.api.SLTApiCall;
import saltr.api.SLTApiCallResult;
import saltr.api.SLTApiFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataConcurrentLoadRefused;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusAppDataParseError;
import saltr.utils.SLTMobileDeviceInfo;
import saltr.utils.dialog.SLTMobileDialogController;
import saltr.utils.level.updater.SLTMobileLevelsFeaturesUpdater;

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
    private var _clientKey:String;
    private var _isLoading:Boolean;

    private var _repositoryStorageManager:SLTRepositoryStorageManager;

    private var _connectSuccessCallback:Function;
    private var _connectFailCallback:Function;

    private var _requestIdleTimeout:int;
    private var _devMode:Boolean;
    private var _autoRegisterDevice:Boolean;
    private var _started:Boolean;
    private var _isSynced:Boolean;
    private var _dialogController:SLTMobileDialogController;

    private var _appData:SLTAppData;

    private var _heartbeatTimer:Timer;
    private var _heartBeatTimerStarted:Boolean;
    private var _apiFactory:SLTApiFactory;
    private var _levelUpdater:SLTMobileLevelsFeaturesUpdater;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     * @param clientKey The client key.
     * @param deviceId The device unique identifier.
     */
    public function SLTSaltrMobile(flashStage:Stage, clientKey:String, deviceId:String) {
        _flashStage = flashStage;
        _clientKey = clientKey;
        _deviceId = deviceId;
        _isLoading = false;
        _heartBeatTimerStarted = false;

        _devMode = false;
        _autoRegisterDevice = true;
        _started = false;
        _isSynced = false;
        _requestIdleTimeout = 0;

        _repositoryStorageManager = new SLTRepositoryStorageManager(new SLTMobileRepository());
        _dialogController = new SLTMobileDialogController(_flashStage, addDeviceToSALTR);

        _appData = new SLTAppData();

        _apiFactory = new SLTApiFactory();
        _levelUpdater = new SLTMobileLevelsFeaturesUpdater(_repositoryStorageManager, _apiFactory, _requestIdleTimeout);
    }

    public function set apiFactory(value:SLTApiFactory):void {
        _apiFactory = value;
        _levelUpdater.apiFactory = _apiFactory;
    }

    /**
     * The repository storage manager.
     */
    public function set repositoryStorageManager(value:SLTRepositoryStorageManager):void {
        _repositoryStorageManager = value;
        _levelUpdater.repositoryStorageManager = _repositoryStorageManager;
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
        _levelUpdater.requestIdleTimeout = _requestIdleTimeout;
    }

    /**
     * Defines the local content root.
     * @param contentRoot The content root url.
     */
    public function setLocalContentRoot(contentRoot:String):void {
        _repositoryStorageManager.setLocalContentRoot(contentRoot);
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
     * Provides the game level feature properties by provided token.
     * @param token The unique identifier of the feature
     * @return Object The feature's properties.
     */
    public function getGameLevelFeatureProperties(token:String):SLTLevelData {
        return _appData.getGameLevelsProperties(token);
    }

    /**
     * Defines game levels by token.
     * @param token The token of "GameLevels" feature.
     */
    public function defineGameLevels(token:String):void {
        if (!_started) {
            var levelData:SLTLevelData = new SLTLevelData();
            // load feature from cache
            var cachedAppData:Object = getCachedAppData();
            var gameLevels:Object = null;
            if (null != cachedAppData) {
                var feature:Object = SLTDeserializer.getFeature(cachedAppData, token, SLTConfig.FEATURE_TYPE_GAME_LEVELS);
                if (null != feature) {
                    gameLevels = feature.properties;
                }
            }

            // if not cached load from application
            if (null == gameLevels) {
                gameLevels = getLevelDataFromApplication(token);
            }
            levelData.initWithData(gameLevels);
            _appData.defineFeature(token, levelData, SLTConfig.FEATURE_TYPE_GAME_LEVELS, true);
        } else {
            throw new Error("Method 'defineGameLevels()' should be called before 'start()' only.");
        }
    }

    /**
     * Define generic feature.
     * @param token The unique identifier of the feature.
     * @param properties The properties of the feature.
     * @param required The required state of the feature.
     */
    public function defineGenericFeature(token:String, properties:Object, required:Boolean = false):void {
        if (_started == false) {
            _appData.defineFeature(token, properties, SLTConfig.FEATURE_TYPE_GENERIC, required);
        } else {
            throw new Error("Method 'defineGenericFeature()' should be called before 'start()' only.");
        }
    }

    /**
     * Starts the instance.
     */
    public function start():void {
        if (_deviceId == null) {
            throw new Error("deviceId field is required and can't be null.");
        }

        var cachedData:Object = getCachedAppData();
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
        var appDataCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_APP_DATA, true);
        appDataCall.call(params, appDataApiCallback, _requestIdleTimeout);
    }

    /**
     * Initialize level content.
     * @param gameLevelsFeatureToken The "GameLevels" feature token
     * @param sltLevel The level.
     * @return TRUE if success, FALSE otherwise.
     */
    public function initLevelContent(gameLevelsFeatureToken:String, sltLevel:SLTLevel):Boolean {
        var content:Object = loadLevelContentInternally(gameLevelsFeatureToken, sltLevel);
        if (null != content) {
            sltLevel.updateContent(content);
            return true;
        } else {
            return false;
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
        var addPropertiesApiCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_ADD_PROPERTIES, true);
        addPropertiesApiCall.call(params, addPropertiesApiCallback, _requestIdleTimeout);
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

        var sendLevelEndEventApiCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_SEND_LEVEL_END, true);
        sendLevelEndEventApiCall.call(params, sendLevelEndApiCallback);
    }

    private function addPropertiesApiCallback(result:SLTApiCallResult):void {
        if (result.success) {
            trace("[addPropertiesApiCallback] success");
        } else {
            trace("[addPropertiesApiCallback] error");
        }
    }

    private function appDataApiCallback(result:SLTApiCallResult):void {
        if (result.success) {
            appDataLoadSuccessCallback(result);
        } else {
            appDataLoadFailCallback(result.status);
        }
    }

    //TODO @GSAR: later we need to report the feature set differences by an event or a callback to client;
    private function appDataLoadSuccessCallback(result:SLTApiCallResult):void {
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
        _repositoryStorageManager.cacheAppData(result.data);

        _connectSuccessCallback();

        if (!_heartBeatTimerStarted) {
            startHeartbeat();
        }

        _levelUpdater.init(_appData.gameLevelsFeatures);
        _levelUpdater.update();
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

    protected function addDeviceFailHandler(result:SLTApiCallResult):void {
        trace("[Saltr] Dev adding new device has failed.");
        _dialogController.showRegistrationFailStatus(result.status.statusMessage);
    }

    private function addDeviceToSALTR(email:String):void {
        var params:Object = {
            email: email,
            clientKey: _clientKey,
            deviceId: _deviceId,
            deviceInfo: SLTMobileDeviceInfo.getDeviceInfo(),
            devMode: _devMode
        };
        var apiCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_REGISTER_DEVICE, true);
        apiCall.call(params, registerDeviceApiCallback);
    }

    private function registerDeviceApiCallback(result:SLTApiCallResult):void {
        if (result.success) {
            addDeviceSuccessHandler();
        } else {
            addDeviceFailHandler(result);
        }
    }

    private function sendLevelEndApiCallback(result:SLTApiCallResult):void {
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
            defaultFeatures: _appData.defaultFeatures
        };
        var syncApiCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_SYNC, true);
        syncApiCall.call(params, syncApiCallback);
    }

    private function syncApiCallback(result:SLTApiCallResult):void {
        if (result.success) {
            syncSuccessHandler();
        } else {
            syncFailHandler(result);
        }
    }

    protected function syncSuccessHandler():void {
        _isSynced = true;
    }

    protected function syncFailHandler(result:SLTApiCallResult):void {
        if (result.status.statusCode == SLTStatus.REGISTRATION_REQUIRED_ERROR_CODE && _autoRegisterDevice) {
            registerDevice();
        }
        else {
            trace("[Saltr] Dev feature Sync has failed. " + result.status.statusMessage);
        }
    }

    private function startHeartbeat():void {
        stopHeartbeat();
        _heartbeatTimer = new Timer(SLTConfig.HEARTBEAT_TIMER_DELAY);
        _heartbeatTimer.addEventListener(TimerEvent.TIMER, heartbeatTimerHandler);
        _heartbeatTimer.start();
        _heartBeatTimerStarted = true;
    }

    private function stopHeartbeat():void {
        if (null != _heartbeatTimer) {
            _heartbeatTimer.stop();
            _heartbeatTimer.removeEventListener(TimerEvent.TIMER, heartbeatTimerHandler);
            _heartbeatTimer = null;
        }
        _heartBeatTimerStarted = false;
    }

    private function heartbeatTimerHandler(event:TimerEvent):void {
        var params:Object = {
            clientKey: _clientKey,
            devMode: _devMode,
            deviceId: _deviceId,
            socialId: _socialId
        };
        var heartbeatApiCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_HEARTBEAT, true);
        heartbeatApiCall.call(params, heartbeatApiCallback);
    }

    private function heartbeatApiCallback(result:SLTApiCallResult):void {
        if (!result.success) {
            stopHeartbeat();
        }
    }

    private function getCachedAppData():Object {
        return _repositoryStorageManager.getAppDataFromCache();
    }

    private function getLevelDataFromApplication(token:String):Object {
        return _repositoryStorageManager.getLevelDataFromApplication(token);
    }

    private function loadLevelContentInternally(gameLevelsFeatureToken:String, level:SLTLevel):Object {
        var content:Object = _repositoryStorageManager.getLevelFromCache(gameLevelsFeatureToken, level.globalIndex);
        if (content == null) {
            content = _repositoryStorageManager.getLevelFromApplication(gameLevelsFeatureToken, level.globalIndex);
        }
        return content;
    }
}
}
