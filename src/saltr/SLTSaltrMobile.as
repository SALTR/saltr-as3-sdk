/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.display.Stage;
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallFactory;
import saltr.api.handler.ISLTApiCallHandler;
import saltr.api.handler.SLTApiCallHandler;
import saltr.game.SLTLevel;
import saltr.repository.ISLTRepository;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataConcurrentLoadRefused;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusAppDataParseError;
import saltr.utils.SLTLogger;
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
    private var _initLevelContentFromSaltrCallback:Function;

    private var _requestIdleTimeout:int;
    private var _devMode:Boolean;
    private var _autoRegisterDevice:Boolean;
    private var _started:Boolean;
    private var _isSynced:Boolean;
    private var _dialogController:SLTMobileDialogController;

    private var _appData:SLTAppData;

    private var _heartbeatTimer:Timer;
    private var _heartBeatTimerStarted:Boolean;
    private var _apiFactory:SLTApiCallFactory;
    private var _levelUpdater:SLTMobileLevelsFeaturesUpdater;
    private var _logger:SLTLogger;

    private var _addPropertiesHandler:SLTApiCallHandler;
    private var _sendLevelEndHandler:SLTApiCallHandler;
    private var _addDeviceToSaltrHandler:SLTApiCallHandler;
    private var _syncHandler:SLTApiCallHandler;
    private var _heartbeatHandler:SLTApiCallHandler;
    private var _connectHandler:SLTApiCallHandler;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     * @param clientKey The client key.
     * @param deviceId The device unique identifier.
     */
    public function SLTSaltrMobile(flashStage:Stage, clientKey:String, deviceId:String) {
        _logger = SLTLogger.getInstance();
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

        initApiCallHandlers();

        _apiFactory = new SLTApiCallFactory();
        _levelUpdater = new SLTMobileLevelsFeaturesUpdater(_repositoryStorageManager, _apiFactory, _requestIdleTimeout);
    }

    /**
     * The API factory.
     */
    public function set apiFactory(value:SLTApiCallFactory):void {
        _apiFactory = value;
        _levelUpdater.apiFactory = _apiFactory;
    }

    /**
     * The repository.
     */
    public function set repository(value:ISLTRepository):void {
        _repositoryStorageManager = new SLTRepositoryStorageManager(value);
        _levelUpdater.repositoryStorageManager = _repositoryStorageManager;
    }

    /**
     * The dev mode state.
     */
    public function set devMode(value:Boolean):void {
        _devMode = value;
        _logger.debug = _devMode;
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
     * @return SLTLevelData The level data object.
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

        if (canGetAppData()) {
            _connectSuccessCallback = successCallback;
            _connectFailCallback = failCallback;
            getAppData(_connectHandler, customProperties);
        } else {
            failCallback(new SLTStatusAppDataConcurrentLoadRefused());
        }
    }

    /**
     * Initialize level content.
     * @param gameLevelsFeatureToken The "GameLevels" feature token
     * @param sltLevel The level.
     * @return TRUE if success, FALSE otherwise.
     */
    public function initLevelContentInternally(gameLevelsFeatureToken:String, sltLevel:SLTLevel):Boolean {
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
    public function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
//        if (!_started) {
//            throw new Error("Method 'initLevelContentLatest' should be called after 'start()' only.");
//        }
//
//        if (canGetAppData()) {
//            _initLevelContentFromSaltrCallback = callback;
//            getAppData(initLevelContentFromSaltrCallback);
//        } else {
//            callback(initLevelContentInternally(gameLevelsFeatureToken, sltLevel));
//        }


//        connect(successCallback, failCallback, null, null);
//
//        function successCallback():void {
//            SLTLogger.getInstance().log("SLTSaltrMobile.initLevelContentLatest connect() success callback called");
//            _levelUpdater.addEventListener(Event.COMPLETE, function (e:Event):void {
//                e.target.removeEventListener(Event.COMPLETE, arguments.callee);
//                SLTLogger.getInstance().log("SLTSaltrMobile.initLevelContentLatest _levelUpdater _complete event received");
//                initLevelContent(gameLevelsFeatureToken, sltLevel);
//
//                callback(true);
//            });
//        }
//
//        function failCallback():void {
//            SLTLogger.getInstance().log("SLTSaltrMobile.initLevelContentLatest() fail callback called");
//            initLevelContent(gameLevelsFeatureToken, sltLevel);
//            callback(false);
//        }
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
        var addPropertiesApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_ADD_PROPERTIES, true);
        addPropertiesApiCall.call(params, _addPropertiesHandler, _requestIdleTimeout);
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

        var sendLevelEndEventApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_SEND_LEVEL_END, true);
        sendLevelEndEventApiCall.call(params, _sendLevelEndHandler);
    }

    private function addDeviceToSALTR(email:String):void {
        var params:Object = {
            email: email,
            clientKey: _clientKey,
            deviceId: _deviceId,
            deviceInfo: SLTMobileDeviceInfo.getDeviceInfo(),
            devMode: _devMode
        };
        var apiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_REGISTER_DEVICE, true);
        apiCall.call(params, _addDeviceToSaltrHandler);
    }

    private function addDeviceToSaltrSuccessHandler(data:Object):void {
        sync();
    }

    private function addDeviceToSaltrFailHandler(status:SLTStatus):void {
        _dialogController.showRegistrationFailStatus(status.statusMessage);
    }

    private function sync():void {
        SLTLogger.getInstance().log("SLTSaltrMobile.sync() called");
        var params:Object = {
            clientKey: _clientKey,
            devMode: _devMode,
            deviceId: _deviceId,
            socialId: _socialId,
            defaultFeatures: _appData.defaultFeatures
        };
        var syncApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_SYNC, true);
        syncApiCall.call(params, _syncHandler);
    }

    private function syncSuccessHandler(data:Object):void {
        _isSynced = true;
    }

    private function syncFailHandler(status:SLTStatus):void {
        if (status.statusCode == SLTStatus.REGISTRATION_REQUIRED_ERROR_CODE && _autoRegisterDevice) {
            registerDevice();
        }
        else {
            trace(status.statusMessage);
        }
    }

    private function connectSuccessHandler(data:Object):void {
        SLTLogger.getInstance().log("SLTSaltrMobile.processConnected() called");
        _isLoading = false;
        if (_devMode && !_isSynced) {
            sync();
        }

        //var levelType:String = result.data.levelType;

        try {
            _appData.initWithData(data);
        } catch (e:Error) {
            _connectFailCallback(new SLTStatusAppDataParseError());
            return;
        }

        _repositoryStorageManager.cacheAppData(data);

        _connectSuccessCallback();

        if (!_heartBeatTimerStarted) {
            startHeartbeat();
        }

        _levelUpdater.init(_appData.gameLevelsFeatures);
        _levelUpdater.update();
    }

    private function connectFailHandler(status:SLTStatus):void {
        SLTLogger.getInstance().log("SLTSaltrMobile.appDataLoadFailCallback() called");
        _isLoading = false;

        if (status.statusCode == SLTStatus.API_ERROR) {
            _connectFailCallback(new SLTStatusAppDataLoadFail());
        } else {
            _connectFailCallback(status);
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
        var heartbeatApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_HEARTBEAT, true);
        heartbeatApiCall.call(params, _heartbeatHandler);
    }

    private function heartbeatFailHandler(status:SLTStatus):void {
        stopHeartbeat();
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

    private function canGetAppData():Boolean {
        return !_isLoading;
    }

    private function getAppData(callHandler:ISLTApiCallHandler, basicProperties:Object = null, customProperties:Object = null):void {
        if (_isLoading) {
            throw new Error("getAppData() is in processing.");
            return;
        }
        _isLoading = true;

        var params:Object = {
            clientKey: _clientKey,
            deviceId: _deviceId,
            devMode: _devMode,
            socialId: _socialId,
            basicProperties: basicProperties,
            customProperties: customProperties
        };
        var appDataCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_APP_DATA, true);
        appDataCall.call(params, callHandler, _requestIdleTimeout);
    }

//    private function initLevelContentFromSaltrCallback(result:SLTApiCallResult):void {
//        _isLoading = false;
//        if (result.success) {
//            //initLevelContentFromSaltrSuccessCallback(result);
//        } else {
//            initLevelContentFromSaltrFailCallback(result.status);
//        }
//    }
//
//    private function initLevelContentFromSaltrFailCallback(status:SLTStatus):void {
//        SLTLogger.getInstance().log("SLTSaltrMobile.initLevelContentFromSaltrFailCallback() called");
//        if (status.statusCode == SLTStatus.API_ERROR) {
//            _connectFailCallback(new SLTStatusAppDataLoadFail());
//        } else {
//            _connectFailCallback(status);
//        }
//    }

    private function initApiCallHandlers():void {
        _addPropertiesHandler = new SLTApiCallHandler("[addPropertiesApiCallback] success", "[addPropertiesApiCallback] error");
        _sendLevelEndHandler = new SLTApiCallHandler("sendLevelEndSuccessHandler", "sendLevelEndFailHandler");
        _addDeviceToSaltrHandler = new SLTApiCallHandler("[Saltr] Dev adding new device has succeed.", "[Saltr] Dev adding new device has failed.", addDeviceToSaltrSuccessHandler, addDeviceToSaltrFailHandler);
        _syncHandler = new SLTApiCallHandler("[Saltr] Dev feature Sync has successed", "[Saltr] Dev feature Sync has failed", syncSuccessHandler, syncFailHandler);
        _heartbeatHandler = new SLTApiCallHandler(null, null, null, heartbeatFailHandler);
        _connectHandler = new SLTApiCallHandler(null, null, connectSuccessHandler, connectFailHandler);
    }
}
}