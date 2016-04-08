/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.display.Stage;
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallResult;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.ISLTRepository;
import saltr.repository.SLTDummyRepository;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataConcurrentLoadRefused;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusAppDataParseError;
import saltr.status.SLTStatusLevelContentLoadFail;
import saltr.status.SLTStatusLevelsParseError;
import saltr.utils.SLTUtils;
import saltr.utils.dialog.SLTWebDialogController;

use namespace saltr_internal;

//TODO @GSAR: add namespaces in all packages to isolate functionality

//TODO:: @daal add some flushCache method.

/**
 * The SLTSaltrWeb class represents the entry point of web SDK.
 */
public class SLTSaltrWeb {
    private var _flashStage:Stage;
    private var _socialId:String;
    private var _platform:String;
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
    private var _dialogController:SLTWebDialogController;

    private var _appData:SLTAppData;
    private var _levelData:SLTLevelData;

    private var _heartbeatTimer:Timer;
    private var _heartBeatTimerStarted:Boolean;
    private var _apiFactory:SLTApiCallFactory;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     * @param clientKey The client key.
     * @param socialId The social identifier.
     */
    public function SLTSaltrWeb(flashStage:Stage, clientKey:String, socialId:String) {
        _flashStage = flashStage;
        _clientKey = clientKey;
        _socialId = socialId;
        _isLoading = false;
        _connected = false;
        _useNoLevels = false;
        _useNoFeatures = false;
        _heartBeatTimerStarted = false;

        _devMode = false;
        _autoRegisterDevice = true;
        _started = false;
        _isSynced = false;
        _requestIdleTimeout = 0;

        _repository = new SLTDummyRepository();
        _dialogController = new SLTWebDialogController(_flashStage, addUserToSALTR);

        _appData = new SLTAppData();
        _levelData = new SLTLevelData();

        _apiFactory = new SLTApiCallFactory();
    }

    public function set apiFactory(value:SLTApiCallFactory):void {
        _apiFactory = value;
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
     * The running platform.
     */
    public function set platform(value:String):void {
        _platform = value;
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
     * Provides the level by provided global index.
     * @param index The global index of the level.
     * @return SLTLevel The level instance specified by index.
     */
    public function getLevelByGlobalIndex(index:int):SLTLevel {
        return _levelData.getLevelByGlobalIndex(index);
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
     * @param json The levels information containing JSON.
     */
    public function importLevelsFromJSON(json:String):void {
        if (_useNoLevels) {
            return;
        }

        if (!_started) {
            var applicationData:Object = JSON.parse(json);
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
//        if (_useNoFeatures) {
//            return;
//        }
//
//        if (_started == false) {
//            _appData.defineFeature(token, properties, required);
//        } else {
//            throw new Error("Method 'defineFeature()' should be called before 'start()' only.");
//        }
    }

    /**
     * Starts the instance.
     */
    public function start():void {
//        if (_socialId == null) {
//            throw new Error("socialId field is required and can't be null.");
//        }
//        if (SLTUtils.getDictionarySize(_appData.developerFeatures) == 0 && _useNoFeatures == false) {
//            throw new Error("Features should be defined.");
//        }
//        _appData.initEmpty();
//        _started = true;
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
            devMode: _devMode,
            socialId: _socialId,
            basicProperties: basicProperties,
            customProperties: customProperties
        };
        var appDataCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_APP_DATA);
//        appDataCall.call(params, appDataApiCallback, _requestIdleTimeout);
    }

    /**
     * Loads the level content.
     * @param sltLevel The level.
     * @param successCallback The success callback function.
     * @param failCallback The fail callback function.
     */
    public function loadLevelContent(sltLevel:SLTLevel, successCallback:Function, failCallback:Function):void {
        _levelContentLoadSuccessCallback = successCallback;
        _levelContentLoadFailCallback = failCallback;
        loadLevelContentFromSaltr(sltLevel);
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
            socialId: _socialId,
            basicProperties: basicProperties,
            customProperties: customProperties
        };
        var addPropertiesApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_ADD_PROPERTIES);
//        addPropertiesApiCall.call(params, addPropertiesApiCallback, _requestIdleTimeout);
    }

    /**
     * Opens user registration dialog.
     */
    public function registerUser():void {
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
            socialId: _socialId,
            endReason: endReason,
            endStatus: endStatus,
            score: score,
            customNumbericProperties: customNumbericProperties,
            customTextProperties: customTextProperties
        };

        var sendLevelEndEventApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_SEND_LEVEL_END);
//        sendLevelEndEventApiCall.call(params, sendLevelEndApiCallback);
    }

    /**
     * Loads the level content.
     * @param sltLevel The level.
     */
    protected function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var params:Object = {
            levelContentUrl: sltLevel.contentUrl + "?_time_=" + new Date().getTime()
        };
        var levelContentApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT);
//        levelContentApiCall.call(params, levelContentApiCallback, _requestIdleTimeout);

        function levelContentApiCallback(result:SLTApiCallResult):void {
            var content:Object = result.data;
            if (result.success && content != null) {
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

        if (!_useNoLevels && levelType != SLTLevel.LEVEL_TYPE_NONE) {
            try {
                _levelData.initWithData(result.data);
            } catch (e:Error) {
                _connectFailCallback(new SLTStatusLevelsParseError());
                return;
            }

        }

        _connected = true;
        _connectSuccessCallback();

        if (!_heartBeatTimerStarted) {
            startHeartbeat();
        }
    }

    private function appDataLoadFailCallback(status:SLTStatus):void {
        _isLoading = false;
        if (status.statusCode == SLTStatus.API_ERROR) {
            _connectFailCallback(new SLTStatusAppDataLoadFail());
        } else {
            _connectFailCallback(status);
        }
    }

    protected function addUserSuccessHandler():void {
        trace("[Saltr] Dev adding new user has succeed.");
        sync();
    }

    protected function addUserFailHandler(result:SLTApiCallResult):void {
        trace("[Saltr] Dev adding new user has failed.");
        _dialogController.showRegistrationFailStatus(result.status.statusMessage);
    }

    private function addUserToSALTR(email:String):void {
        var params:Object = {
            email: email,
            clientKey: _clientKey,
            socialId: _socialId,
            platform: _platform,
            devMode: _devMode
        };
        var apiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_REGISTER_USER);
//        apiCall.call(params, registerUserApiCallback);
    }

    private function registerUserApiCallback(result:SLTApiCallResult):void {
        if (result.success) {
            addUserSuccessHandler();
        } else {
            addUserFailHandler(result);
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
//        var params:Object = {
//            clientKey: _clientKey,
//            devMode: _devMode,
//            socialId: _socialId,
//            developerFeatures: _appData.developerFeatures
//        };
//        var syncApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_SYNC, false);
//        syncApiCall.call(params, syncApiCallback);
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
            registerUser();
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
            socialId: _socialId
        };
        var heartbeatApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_HEARTBEAT);
//        heartbeatApiCall.call(params, heartbeatApiCallback);
    }

    private function heartbeatApiCallback(result:SLTApiCallResult):void {
        if (!result.success) {
            stopHeartbeat();
        }
    }
}
}
