/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.display.Stage;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;

import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallFactory;
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


/**
 * The SLTSaltrMobile class represents the entry point of mobile SDK.
 */
public class SLTSaltrMobile {
    private var _flashStage:Stage;
    private var _socialId:String;
    private var _deviceId:String;
    private var _clientKey:String;
    private var _isWaitingForAppData:Boolean;

    private var _repositoryStorageManager:SLTRepositoryStorageManager;

    private var _connectSuccessCallback:Function;
    private var _connectFailCallback:Function;
    private var _dedicatedLevelData:DedicatedLevelData;

    private var _requestIdleTimeout:int;
    private var _devMode:Boolean;
    private var _started:Boolean;

    private var _appData:SLTAppData;

    private var _heartbeatTimer:Timer;
    private var _heartBeatTimerStarted:Boolean;
    private var _apiFactory:SLTApiCallFactory;
    private var _levelUpdater:SLTMobileLevelsFeaturesUpdater;
    private var _logger:SLTLogger;

    private var _validator:SLTFeatureValidator;

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
        _isWaitingForAppData = false;
        _heartBeatTimerStarted = false;

        _devMode = false;
        _started = false;
        _requestIdleTimeout = 0;

        _validator = new SLTFeatureValidator();
        _repositoryStorageManager = new SLTRepositoryStorageManager(new SLTMobileRepository());

        _appData = new SLTAppData();

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
     * The verbose logging state.
     * Note: This works only in development mode
     */
    public function set verboseLogging(value:Boolean):void {
        _logger.verboseLogging = value;
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

    public function addValidator(featureToken:String, validator:Function):void {
        _validator.addValidator(featureToken, validator);
    }

    /**
     * Starts the instance.
     */
    public function start():void {
        if (_deviceId == null) {
            throw new Error("deviceId field is required and can't be null.");
        }
        _appData.initDefaultFeatures({features: getAppDataFromApplication()});
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
        SLTLogger.getInstance().log("Method 'connect()' called.");
        if (!_started) {
            throw new Error("Method 'connect()' should be called after 'start()' only.");
        }

        if (canGetAppData()) {
            _connectSuccessCallback = successCallback;
            _connectFailCallback = failCallback;
            getAppData(appDataConnectSuccessHandler, appDataConnectFailHandler, false, basicProperties, customProperties);
        } else {
            SLTLogger.getInstance().log("Connect failed. Concurrent load accrues.");
            failCallback(new SLTStatusAppDataConcurrentLoadRefused());
        }
    }

    /**
     * Sends Ping GetAppData call to Saltr.
     */
    public function ping():void {
        if (canGetAppData()) {
            getAppData(pingCallback, pingCallback, true);
        }
    }

    /**
     * Initialize level content.
     * @param gameLevelsFeatureToken The "GameLevels" feature token
     * @param sltLevel The level.
     * @return TRUE if success, FALSE otherwise.
     */
    public function initLevelContentLocally(gameLevelsFeatureToken:String, sltLevel:SLTLevel):Boolean {
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
        if (!_started) {
            throw new Error("Method 'initLevelContentFromSaltr' should be called after 'start()' only.");
        }

        _dedicatedLevelData = new DedicatedLevelData(gameLevelsFeatureToken, sltLevel, callback);
        if (canGetAppData()) {
            getAppData(appDataInitLevelSuccessHandler, appDataInitLevelFailHandler);
        } else {
            updateDedicatedLevelContent();
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
        var addPropertiesApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_ADD_PROPERTIES, true);
        addPropertiesApiCall.call(params, addPropertiesSuccessHandler, addPropertiesFailHandler, _requestIdleTimeout);
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
        sendLevelEndEventApiCall.call(params, sendLevelEndSuccessHandler, sendLevelEndFailHandler);
    }

    private function addPropertiesSuccessHandler(data:Object):void {
        trace("[addPropertiesApiCallback] success");
    }

    private function addPropertiesFailHandler(status:SLTStatus):void {
        trace("[addPropertiesApiCallback] error");
    }

    private function sendLevelEndSuccessHandler(data:Object):void {
        trace("sendLevelEndSuccessHandler");
    }

    private function sendLevelEndFailHandler(status:SLTStatus):void {
        trace("sendLevelEndFailHandler");
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
        heartbeatApiCall.call(params, null, heartbeatFailHandler);
    }

    private function heartbeatFailHandler(status:SLTStatus):void {
        stopHeartbeat();
    }

    private function getCachedAppData():Object {
        return _repositoryStorageManager.getAppDataFromCache();
    }

    private function getAppDataFromApplication():Object {
        return _repositoryStorageManager.getAppDataFromApplication();
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
        return !_isWaitingForAppData;
    }

    private function getAppData(successHandler:Function, failHandler:Function, ping:Boolean = false, basicProperties:Object = null, customProperties:Object = null):void {
        _isWaitingForAppData = true;

        var params:Object = {
            clientKey: _clientKey,
            deviceId: _deviceId,
            devMode: _devMode,
            ping: ping,
            socialId: _socialId,
            basicProperties: basicProperties,
            customProperties: customProperties
        };
        var appDataCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_APP_DATA, true);
        appDataCall.call(params, successHandler, failHandler, _requestIdleTimeout);
        SLTLogger.getInstance().log("New app data requested.");
    }

    private function pingCallback(data:Object):void {
        _isWaitingForAppData = false;
    }

    private function appDataConnectSuccessHandler(data:Object):void {
        SLTLogger.getInstance().log("New app data request from connect() succeed.");
        _isWaitingForAppData = false;
        if (processNewAppData(data)) {
            _levelUpdater.update(_appData.gameLevelsFeatures);
            _connectSuccessCallback();
        } else {
            _connectFailCallback(new SLTStatusAppDataParseError());
        }
    }

    private function processNewAppData(data:Object):Boolean {
        try {
            _appData.initWithData(data);
            validateFeatures();
        } catch (e:Error) {
            SLTLogger.getInstance().log("New app data process failed.");
            return false;
        }

        _repositoryStorageManager.cacheAppData(data);

        if (!_heartBeatTimerStarted) {
            startHeartbeat();
        }
        SLTLogger.getInstance().log("New app data processed.");
        return true;
    }

    private function validateFeatures():void {
        var activeFeatures:Dictionary = _appData.activeFeatures;
        for each (var feature:SLTFeature  in activeFeatures) {
            if (!_validator.validate(feature)) {
                feature.isValid = false;
            }
        }
    }

    private function appDataConnectFailHandler(status:SLTStatus):void {
        SLTLogger.getInstance().log("New app data request from connect() failed. StatusCode: " + status.statusCode);
        _isWaitingForAppData = false;

        if (status.statusCode == SLTStatus.API_ERROR) {
            _connectFailCallback(new SLTStatusAppDataLoadFail());
        } else {
            _connectFailCallback(status);
        }
    }

    private function appDataInitLevelSuccessHandler(data:Object):void {
        _isWaitingForAppData = false;
        if (processNewAppData(data)) {
            var newLevel:SLTLevel = getGameLevelFeatureProperties(_dedicatedLevelData.gameLevelsFeatureToken).getLevelByGlobalIndex(_dedicatedLevelData.level.globalIndex);
            _levelUpdater.addEventListener(Event.COMPLETE, dedicatedLevelUpdateCompleteHandler);
            _levelUpdater.updateLevel(_dedicatedLevelData.gameLevelsFeatureToken, newLevel);
        } else {
            updateDedicatedLevelContent();
        }
    }

    private function dedicatedLevelUpdateCompleteHandler(event:Event):void {
        _levelUpdater.removeEventListener(Event.COMPLETE, dedicatedLevelUpdateCompleteHandler);
        updateDedicatedLevelContent();
    }

    private function appDataInitLevelFailHandler(status:SLTStatus):void {
        _isWaitingForAppData = false;
        updateDedicatedLevelContent();
    }

    private function updateDedicatedLevelContent():void {
        _dedicatedLevelData.callback(initLevelContentLocally(_dedicatedLevelData.gameLevelsFeatureToken, _dedicatedLevelData.level));
    }
}
}

import saltr.game.SLTLevel;

internal class DedicatedLevelData {
    private var _gameLevelsFeatureToken:String;
    private var _level:SLTLevel;
    private var _callback:Function;

    public function DedicatedLevelData(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        _gameLevelsFeatureToken = gameLevelsFeatureToken;
        _level = sltLevel;
        _callback = callback;
    }

    public function get gameLevelsFeatureToken():String {
        return _gameLevelsFeatureToken;
    }

    public function get level():SLTLevel {
        return _level;
    }

    public function get callback():Function {
        return _callback;
    }
}