/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.display.Stage;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.system.Capabilities;
import flash.utils.Dictionary;

import saltr.api.AddPropertiesApiCall;

import saltr.api.ApiCall;
import saltr.api.ApiCallResult;
import saltr.api.AppDataApiCall;
import saltr.api.LevelContentApiCall;

import saltr.api.RegisterDeviceApiCall;
import saltr.api.SendLevelEndEventApiCall;
import saltr.api.SyncApiCall;
import saltr.game.SLTLevel;

import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;
import saltr.repository.ISLTRepository;
import saltr.repository.SLTDummyRepository;
import saltr.repository.SLTMobileRepository;
import saltr.resource.SLTResource;
import saltr.resource.SLTResourceURLTicket;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataConcurrentLoadRefused;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusExperimentsParseError;
import saltr.status.SLTStatusFeaturesParseError;
import saltr.status.SLTStatusLevelContentLoadFail;
import saltr.status.SLTStatusLevelsParseError;
import saltr.utils.DeviceRegistrationDialog;
import saltr.utils.DialogController;
import saltr.utils.MobileDeviceInfo;
import saltr.utils.Utils;
import saltr.saltr_internal;

use namespace saltr_internal;

//TODO @GSAR: add namespaces in all packages to isolate functionality

//TODO:: @daal add some flushCache method.
public class SLTSaltrMobile {

    public static const CLIENT:String = "AS3-Mobile";
    public static const API_VERSION:String = "1.0.0";

    private var _flashStage:Stage;
    private var _socialId:String;
    private var _deviceId:String;
    private var _connected:Boolean;
    private var _clientKey:String;
    private var _isLoading:Boolean;

    private var _repository:ISLTRepository;

    private var _activeFeatures:Dictionary;
    private var _developerFeatures:Dictionary;

    private var _experiments:Vector.<SLTExperiment>;
    private var _levelPacks:Vector.<SLTLevelPack>;

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
    private var _levelType:String;
    private var _dialogController:DialogController;

    private static function getTicket(url:String, vars:URLVariables, timeout:int = 0):SLTResourceURLTicket {
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(url, vars);
        ticket.method = URLRequestMethod.POST;
        if (timeout > 0) {
            ticket.idleTimeout = timeout;
        }
        return ticket;
    }

    public function SLTSaltrMobile(flashStage:Stage, clientKey:String, deviceId:String, useCache:Boolean = true) {
        _flashStage = flashStage;
        _clientKey = clientKey;
        _deviceId = deviceId;
        _isLoading = false;
        _connected = false;
        _useNoLevels = false;
        _useNoFeatures = false;
        _levelType = null;

        _devMode = false;
        _autoRegisterDevice = true;
        _started = false;
        _isSynced = false;
        _requestIdleTimeout = 0;

        _activeFeatures = new Dictionary();
        _developerFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
        _levelPacks = new <SLTLevelPack>[];

        _repository = useCache ? new SLTMobileRepository() : new SLTDummyRepository();
        _dialogController = new DialogController(_flashStage, addDeviceToSALTR);
    }

    public function set repository(value:ISLTRepository):void {
        _repository = value;
    }

    public function set useNoLevels(value:Boolean):void {
        _useNoLevels = value;
    }

    public function set useNoFeatures(value:Boolean):void {
        _useNoFeatures = value;
    }

    public function set devMode(value:Boolean):void {
        _devMode = value;
    }

    public function set autoRegisterDevice(value:Boolean):void {
        _autoRegisterDevice = value;
    }

    public function set requestIdleTimeout(value:int):void {
        _requestIdleTimeout = value;
    }

    public function get levelPacks():Vector.<SLTLevelPack> {
        return _levelPacks;
    }

    public function get allLevels():Vector.<SLTLevel> {
        var allLevels:Vector.<SLTLevel> = new Vector.<SLTLevel>();
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            var levels:Vector.<SLTLevel> = _levelPacks[i].levels;
            for (var j:int = 0, len2:int = levels.length; j < len2; ++j) {
                allLevels.push(levels[j]);
            }
        }

        return allLevels;
    }

    public function get allLevelsCount():uint {
        var count:uint = 0;
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            count += _levelPacks[i].levels.length;
        }

        return count;
    }

    public function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    public function set socialId(socialId:String):void {
        _socialId = socialId;
    }

    public function getLevelByGlobalIndex(index:int):SLTLevel {
        var levelsSum:int = 0;
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            var packLength:int = _levelPacks[i].levels.length;
            if (index >= levelsSum + packLength) {
                levelsSum += packLength;
            } else {
                var localIndex:int = index - levelsSum;
                return _levelPacks[i].levels[localIndex];
            }
        }
        return null;
    }

    public function getPackByLevelGlobalIndex(index:int):SLTLevelPack {
        var levelsSum:int = 0;
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            var packLength:int = _levelPacks[i].levels.length;
            if (index >= levelsSum + packLength) {
                levelsSum += packLength;
            } else {
                return _levelPacks[i];
            }
        }
        return null;
    }

    public function getActiveFeatureTokens():Vector.<String> {
        var tokens:Vector.<String> = new Vector.<String>();
        for each(var feature:SLTFeature in _activeFeatures) {
            tokens.push(feature.token);
        }

        return tokens;
    }

    public function getFeatureProperties(token:String):Object {
        var activeFeature:SLTFeature = _activeFeatures[token];
        if (activeFeature != null) {
            return activeFeature.properties;
        } else {
            var devFeature:SLTFeature = _developerFeatures[token];
            if (devFeature != null && devFeature.required) {
                return devFeature.properties;
            }
        }

        return null;
    }

    public function importLevels(path:String = null):void {
        if (_useNoLevels) {
            return;
        }

        if (!_started) {
            path = path == null ? SLTConfig.LOCAL_LEVELPACK_PACKAGE_URL : path;
            var applicationData:Object = _repository.getObjectFromApplication(path);
            _levelPacks = SLTDeserializer.decodeLevels(applicationData);
        } else {
            throw new Error("Method 'importLevels()' should be called before 'start()' only.");
        }
    }

    /**
     * If you want to have a feature synced with SALTR you should call define before getAppData call.
     */
    public function defineFeature(token:String, properties:Object, required:Boolean = false):void {
        if (_useNoFeatures) {
            return;
        }

        if (_started == false) {
            _developerFeatures[token] = new SLTFeature(token, properties, required);
        } else {
            throw new Error("Method 'defineFeature()' should be called before 'start()' only.");
        }
    }

    public function start():void {
        if (_deviceId == null) {
            throw new Error("deviceId field is required and can't be null.");
        }

        if (Utils.getDictionarySize(_developerFeatures) == 0 && _useNoFeatures == false) {
            throw new Error("Features should be defined.");
        }

        if (_levelPacks.length == 0 && _useNoLevels == false) {
            throw new Error("Levels should be imported.");
        }

        var cachedData:Object = _repository.getObjectFromCache(SLTConfig.APP_DATA_URL_CACHE);
        if (cachedData == null) {
            for (var i:String in _developerFeatures) {
                _activeFeatures[i] = _developerFeatures[i];
            }
        } else {
            _activeFeatures = SLTDeserializer.decodeFeatures(cachedData);
            _experiments = SLTDeserializer.decodeExperiments(cachedData);
        }

        _started = true;
    }

    public function connect(successCallback:Function, failCallback:Function, basicProperties:Object = null, customProperties:Object = null):void {
        if(!_started) {
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
            clientKey:_clientKey,
            deviceId:_deviceId,
            devMode:_devMode,
            socialId:_socialId,
            basicProperties:basicProperties,
            customProperties:customProperties
        };
        var appDataCall:AppDataApiCall = new AppDataApiCall(params);
        appDataCall.call(appDataApiCallback, _requestIdleTimeout);
    }

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

    public function addProperties(basicProperties:Object = null, customProperties:Object = null):void {
        if (!basicProperties && !customProperties) {
            return;
        }

        var params:Object = {
            clientKey:_clientKey,
            deviceId:_deviceId,
            socialId:_socialId,
            basicProperties:basicProperties,
            customProperties:customProperties
        };
        var addPropertiesApiCall:AddPropertiesApiCall = new AddPropertiesApiCall(params);
        addPropertiesApiCall.call(addPropertiesApiCallback, _requestIdleTimeout);
    }

    public function registerDevice() {
        if(!_started) {
            throw new Error("Method 'registerDevice()' should be called after 'start()' only.");
        }
        _dialogController.showDeviceRegistrationDialog();
    }

    //anakonda
    private static function removeEmptyAndNullsJSONReplacer(k:*, v:*):* {
        if (v != null && v != "null" && v !== "") {
            return v;
        }
        return undefined;
    }

    protected function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var params:Object = {
            sltLevel:sltLevel
        };
        var levelContentApiCall:LevelContentApiCall = new LevelContentApiCall(params);
        levelContentApiCall.call(levelContentApiCallback, _requestIdleTimeout);
    }

    private function levelContentApiCallback(result:ApiCallResult):void {
        function loadInternally(sltLevel:SLTLevel, content:Object):void {
            if (content != null) {
                levelContentLoadSuccessHandler(sltLevel, content);
            }
            else {
                levelContentLoadFailHandler();
            }
        }

        if(result.success) {
            cacheLevelContent(result.data.sltLevel, result.data.content);
        } else {
            var content:Object = loadLevelContentInternally(result.data.sltLevel);
            loadInternally(result.data.sltLevel, content);
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
        if(result.success) {
            trace("success");
        } else {
            trace("error");
        }
    }

    private function appDataApiCallback(result:ApiCallResult):void {
        if(result.success) {
            appDataLoadSuccessCallback(result);
        } else {
            appDataLoadFailCallback(result.errorCode, result.errorMessage);
        }
    }

    private function appDataLoadSuccessCallback(result:ApiCallResult):void {
        _isLoading = false;

        if (_devMode && !_isSynced) {
            sync();
        }

        _levelType = result.data.levelType;
         var saltrFeatures:Dictionary;
         try {
             saltrFeatures = SLTDeserializer.decodeFeatures(result.data);
         } catch (e:Error) {
            _connectFailCallback(new SLTStatusFeaturesParseError());
            return;
         }

         try {
             _experiments = SLTDeserializer.decodeExperiments(result.data);
         } catch (e:Error) {
             _connectFailCallback(new SLTStatusExperimentsParseError());
             return;
         }

         // if developer didn't announce use without levels, and levelType in returned JSON is not "noLevels",
         // then - parse levels
         if (!_useNoLevels && _levelType != SLTLevel.LEVEL_TYPE_NONE) {
             var newLevelPacks:Vector.<SLTLevelPack>;
             try {
                 newLevelPacks = SLTDeserializer.decodeLevels(result.data);
             } catch (e:Error) {
                 _connectFailCallback(new SLTStatusLevelsParseError());
                 return;
             }

             // if new levels are received and parsed, then only dispose old ones and assign new ones.
             if (newLevelPacks != null) {
                 disposeLevelPacks();
                 _levelPacks = newLevelPacks;
             }
         }

         _connected = true;
         _repository.cacheObject(SLTConfig.APP_DATA_URL_CACHE, "0", result.data);

         _activeFeatures = saltrFeatures;
         _connectSuccessCallback();

         trace("[SALTR] AppData load success. LevelPacks loaded: " + _levelPacks.length);
         //TODO @GSAR: later we need to report the feature set differences by an event or a callback to client;
    }

    private function appDataLoadFailCallback(errorCode:int, message:String):void {
        _isLoading = false;
        if(-1 == errorCode) {
            _connectFailCallback(new SLTStatusAppDataLoadFail());
        } else {
            _connectFailCallback(new SLTStatus(errorCode, message));
        }
    }

    protected function addDeviceSuccessHandler():void {
        trace("[Saltr] Dev adding new device has succeed.");
        sync();
    }

    protected function addDeviceFailHandler(message:String):void {
        trace("[Saltr] Dev adding new device has failed.");
        _dialogController.showDeviceRegistrationFailStatus(message);
    }

    private function addDeviceToSALTR(email:String):void {
        var params:Object = {
            email : email,
            clientKey:_clientKey,
            deviceId:_deviceId,
            deviceInfo:MobileDeviceInfo.getDeviceInfo(),
            devMode:_devMode
        };
        var apiCall:ApiCall = new RegisterDeviceApiCall(params);
        apiCall.call(registerDeviceApiCallback);
    }

    private function registerDeviceApiCallback(result:ApiCallResult):void {
        if(result.success) {
            addDeviceSuccessHandler();
        } else {
            addDeviceFailHandler(result.errorMessage);
        }
    }

    private function disposeLevelPacks():void {
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            _levelPacks[i].dispose();
        }
        _levelPacks.length = 0;
    }

    public function sendLevelEndEvent(variationId:String, endStatus:String, endReason:String, score:int, customTextProperties:Array, customNumbericProperties:Array):void {
        var params:Object = {
            clientKey:_clientKey,
            devMode:_devMode,
            variationId:variationId,
            deviceId:_deviceId,
            socialId:_socialId,
            endReason:endReason,
            endStatus:endStatus,
            score:score,
            customNumbericProperties:customNumbericProperties,
            customTextProperties:customTextProperties
        };

        var sendLevelEndEventApiCall:SendLevelEndEventApiCall = new SendLevelEndEventApiCall(params);
        sendLevelEndEventApiCall.call(sendLevelEndApiCallback);
    }

    private function sendLevelEndApiCallback(result:ApiCallResult):void {
        if(result.success) {
            trace("sendLevelEndSuccessHandler");
        } else {
            trace("sendLevelEndFailHandler");
        }
    }

    private function sync():void {
        var params:Object = {
            clientKey:_clientKey,
            devMode:_devMode,
            deviceId:_deviceId,
            socialId:_socialId,
            developerFeatures:_developerFeatures
        };
        var syncApiCall:SyncApiCall = new SyncApiCall(params);
        syncApiCall.call(syncApiCallback);
    }

    private function syncApiCallback(result:ApiCallResult):void {
        if(result.success) {
            syncSuccessHandler();
        } else {
            syncFailHandler(result);
        }
    }

    protected function syncSuccessHandler():void {
        _isSynced = true;
    }

    protected function syncFailHandler(result:ApiCallResult):void {
        if(result.errorCode == SLTStatus.REGISTRATION_REQUIRED_ERROR_CODE && _autoRegisterDevice) {
            registerDevice();
        }
        else {
            trace("[Saltr] Dev feature Sync has failed. " + result.errorMessage);
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
