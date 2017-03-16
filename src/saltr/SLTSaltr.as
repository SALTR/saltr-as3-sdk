/**
 * Created by daal on 4/7/16.
 */
package saltr {
import flash.events.TimerEvent;
import flash.utils.Timer;

import saltr.api.call.SLTApiCall;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.game.SLTLevel;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataConcurrentLoadRefused;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

public class SLTSaltr implements ISLTSaltr {

    protected var _socialId:String;
    protected var _deviceId:String;
    protected var _clientKey:String;
    protected var _isWaitingForAppData:Boolean;

    protected var _basicProperties:SLTBasicProperties;
    protected var _customProperties:Object;
    protected var _logger:SLTLogger;

    protected var _nativeTimeout:int;
    protected var _dropTimeout:int;
    protected var _timeoutIncrease:int;
    protected var _devMode:Boolean;
    protected var _started:Boolean;

    protected var _appData:SLTAppData;
    protected var _validator:SLTFeatureValidator;

    protected var _heartbeatTimer:Timer;
    protected var _heartBeatTimerStarted:Boolean;

    protected var _connectSuccessCallback:Function;
    protected var _connectFailCallback:Function;

    public function SLTSaltr(clientKey:String, deviceId:String = null, socialId:String = null) {
        _clientKey = clientKey;
        _deviceId = deviceId;
        _socialId = socialId;

        _heartBeatTimerStarted = false;
        _devMode = false;
        _started = false;
        _nativeTimeout = 0;
        _dropTimeout = 0;
        _timeoutIncrease = 0;
        _logger = SLTLogger.getInstance();
        _appData = new SLTAppData();

        _validator = new SLTFeatureValidator();
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
     * The request idle timeout. Works on mobile platform only. For Web version dropTimeout should be used.
     */
    public function set nativeTimeout(value:int):void {
        _nativeTimeout = value;
    }

    /**
     * The request drop timeout.
     */
    public function set dropTimeout(value:int):void {
        _dropTimeout = value;
    }

    /**
     * The request progressive timeout.
     */
    public function set timeoutIncrease(value:int):void {
        _timeoutIncrease = value;
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

    protected function canGetAppData():Boolean {
        return !_isWaitingForAppData;
    }

    public function start():void {
        //abstract...
    }

    public function initLevelContent(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function, fromSaltr:Boolean = false):void {
        if (!_started) {
            throw new Error("Method 'initLevelContent' should be called after 'start()' only.");
        }
        sltLevel.contentReady = false;

        if (fromSaltr) {
            initLevelContentFromSaltr(gameLevelsFeatureToken, sltLevel, callback);
        }
        else {
            initLevelContentLocally(gameLevelsFeatureToken, sltLevel);
            callback(true);
        }
    }

    protected function initLevelContentLocally(gameLevelsFeatureToken:String, sltLevel:SLTLevel):void {
    }

    protected function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
    }

    public function sendLevelReport(successCallback:Function, failCallback:Function, properties:Object):void {
        var params:Object = {
            clientKey: _clientKey,
            deviceId: _deviceId,
            socialId: _socialId,
            levelReportEventProperties: properties
        };

        var levelReportApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_LEVEL_REPORT);
        levelReportApiCall.call(params, successCallback, failCallback, _nativeTimeout, _dropTimeout, _timeoutIncrease);
    }

    /**
     * Establishes the connection to Saltr server.
     */
    public function connect(successCallback:Function, failCallback:Function, basicProperties:SLTBasicProperties, customProperties:Object = null):void {
        SLTLogger.getInstance().log("Method 'connect()' called.");
        if (!_started) {
            throw new Error("Method 'connect()' should be called after 'start()' only.");
        }

        if (canGetAppData()) {
            _connectSuccessCallback = successCallback;
            _connectFailCallback = failCallback;
            updateMissingProperties(basicProperties);
            _customProperties = customProperties;
            _basicProperties = basicProperties;
            getAppData(appDataConnectSuccessHandler, appDataConnectFailHandler, false, _basicProperties, _customProperties);
        } else {
            SLTLogger.getInstance().log("Connect failed. Concurrent load accrues.");
            failCallback(new SLTStatusAppDataConcurrentLoadRefused());
        }
    }

    protected function updateMissingProperties(basicProperties:SLTBasicProperties):void {
        //abstract....
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
        var addPropertiesApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_ADD_PROPERTIES);
        addPropertiesApiCall.call(params, addPropertiesSuccessHandler, addPropertiesFailHandler, _nativeTimeout, _dropTimeout, _timeoutIncrease);
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

        var sendLevelEndEventApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_SEND_LEVEL_END);
        sendLevelEndEventApiCall.call(params, sendLevelEndSuccessHandler, sendLevelEndFailHandler);
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
        var heartbeatApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_HEARTBEAT);

        heartbeatApiCall.call(params, null, heartbeatFailHandler);
    }

    private function heartbeatFailHandler(status:SLTStatus):void {
        stopHeartbeat();
    }

    protected function getAppData(successHandler:Function, failHandler:Function, ping:Boolean = false, basicProperties:Object = null, customProperties:Object = null, additionalApiCallParams:Object = null):void {
        _isWaitingForAppData = true;

        var params:Object = {
            clientKey: _clientKey,
            deviceId: _deviceId,
            devMode: _devMode,
            ping: ping,
            socialId: _socialId,
            basicProperties: basicProperties,
            customProperties: customProperties,
            snapshotId: _appData.snapshotId,
            context: "main"
        };

        if (additionalApiCallParams != null) {
            for (var i:String in additionalApiCallParams) {
                params[i] = additionalApiCallParams[i];
            }
        }

        var appDataCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_APP_DATA, _appData);
        appDataCall.call(params, successHandler, failHandler, _nativeTimeout, _dropTimeout, _timeoutIncrease);
        SLTLogger.getInstance().log("New app data requested.");
    }

    /**
     * Sends Ping GetAppData call to Saltr.
     */
    public function ping(successCallback:Function = null, failCallback:Function = null):void {
        if (canGetAppData()) {
            _connectSuccessCallback = successCallback;
            _connectFailCallback = failCallback;
            getAppData(appDataConnectSuccessHandler, appDataConnectFailHandler, true, _basicProperties, _customProperties);
        }
    }

    protected function appDataConnectSuccessHandler(data:SLTAppData):void {
        _appData = data;
        _isWaitingForAppData = false;
        _connectSuccessCallback();

        if (!_heartBeatTimerStarted) {
            startHeartbeat();
        }
    }

    protected function appDataConnectFailHandler(status:SLTStatus):void {
        SLTLogger.getInstance().log("New app data request from connect() failed. StatusCode: " + status.statusCode);
        _isWaitingForAppData = false;

        if (status.statusCode == SLTStatus.API_ERROR) {
            _connectFailCallback(new SLTStatusAppDataLoadFail());
        } else {
            _connectFailCallback(status);
        }
    }
}
}
