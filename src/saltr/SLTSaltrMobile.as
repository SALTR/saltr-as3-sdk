/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: daal
 * Date: 6/12/12
 * Time: 7:26 PM
 */
package saltr {
import flash.net.URLVariables;
import flash.utils.Dictionary;

import saltr.parser.game.SLTLevel;
import saltr.parser.game.SLTLevelPack;
import saltr.repository.ISLTRepository;
import saltr.repository.SLTDummyRepository;
import saltr.repository.SLTMobileRepository;
import saltr.resource.SLTResource;
import saltr.resource.SLTResourceURLTicket;
import saltr.utils.Utils;

//TODO:: @daal add some flushCache method.
public class SLTSaltrMobile {

    protected var _partner:SLTPartner;
    protected var _device:SLTDevice;
    protected var _connected:Boolean;
    protected var _clientKey:String;
    protected var _saltrUserId:String;
    protected var _isLoading:Boolean;

    protected var _repository:ISLTRepository;

    protected var _activeFeatures:Dictionary;
    protected var _developerFeatures:Dictionary;

    protected var _experiments:Vector.<SLTExperiment>;
    protected var _levelPacks:Vector.<SLTLevelPack>;

    protected var _appDataLoadSuccessCallback:Function;
    protected var _appDataLoadFailCallback:Function;
    protected var _levelContentLoadSuccessCallback:Function;
    protected var _levelContentLoadFailCallback:Function;

    private var _devMode:Boolean;
    private var _appVersion:String;
    private var _started:Boolean;
    private var _useNoLevels:Boolean;
    private var _useNoFeatures:Boolean;


    //TODO @GSAR: clean up all classes method order - to give SDK a representative look!
    public function SLTSaltrMobile(clientKey:String, useCache:Boolean = true) {
        _clientKey = clientKey;
        _isLoading = false;
        _connected = false;

        _useNoLevels = false;
        _useNoFeatures = false;

        //TODO @GSAR: implement usage of dev mode variable
        _devMode = true;
        _started = false;

        _activeFeatures = new Dictionary();
        _developerFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];

        _repository = useCache ? new SLTMobileRepository() : new SLTDummyRepository();
    }

    public function set appVersion(value:String):void {
        _appVersion = value;
    }

    public function set repository(value:ISLTRepository):void {
        _repository = value;
    }

    public function get levelPacks():Vector.<SLTLevelPack> {
        return _levelPacks;
    }

    public function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    public function setPartner(partnerId:String, partnerType:String):void {
        _partner = new SLTPartner(partnerId, partnerType);
    }

    public function setDevice(deviceId:String, deviceType:String):void {
        _device = new SLTDevice(deviceId, deviceType);
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
        if (_started == false) {
            path = path == null ? SLTConfig.LEVEL_PACK_URL_PACKAGE : path;
            var applicationData:Object = _repository.getObjectFromApplication(path);
            _levelPacks = SLTDeserializer.decodeLevels(applicationData);
        } else {
            //TODO @GSAR: try to throw an error or warning here!
        }
    }

    /**
     * If you want to have a feature synced with SALTR you should call define before getAppData call.
     */
        //TODO @GSAR: add Properties class to handle correct feature properties assignment
    public function defineFeature(token:String, properties:Object, required:Boolean = false):void {
        if (_started == false) {
            _developerFeatures[token] = new SLTFeature(token, properties, required);
        } else {
            //TODO @GSAR: try to throw an error or warning here!
        }
    }

    public function start():void {
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
            _saltrUserId = cachedData.saltrUserId;
        }

        _started = true;
    }

    public function connect(loadSuccessCallback:Function, loadFailCallback:Function):void {
        if (_isLoading || !_started) {
            return;
        }
        _appDataLoadSuccessCallback = loadSuccessCallback;
        _appDataLoadFailCallback = loadFailCallback;

        _isLoading = true;
        var resource:SLTResource = createAppDataResource(appDataLoadSuccessHandler, appDataLoadFailHandler);
        resource.load();
    }

    /////////////////////////////////////// level content data loading methods.

    public function loadLevelContent(levelPack:SLTLevelPack, level:SLTLevel, loadSuccessCallback:Function, loadFailCallback:Function, useCache:Boolean = true):void {
        _levelContentLoadSuccessCallback = loadSuccessCallback;
        _levelContentLoadFailCallback = loadFailCallback;
        if (!useCache) {
            loadLevelContentFromSALTR(levelPack, level, true);
        }
        else {
            //if there are no version change than load from cache
            var cachedVersion:String = getCachedLevelVersion(levelPack, level);
            if (level.version == cachedVersion) {
                var contentData:Object = loadLevelContentFromCache(levelPack, level);
                levelContentLoadSuccessHandler(level, contentData);
            }
            else {
                loadLevelContentFromSALTR(levelPack, level);
            }
        }
    }

    private function appDataLoadFailHandler(resource:SLTResource):void {
        trace("[Saltr] App data is failed to load.");
        resource.dispose();
        _isLoading = false;
        _appDataLoadFailCallback(new SLTError(SLTError.GENERAL_ERROR_CODE, "[SALTR] Failed to load appData."));
    }

    private function appDataLoadSuccessHandler(resource:SLTResource):void {
        var data:Object = resource.jsonData;
        var status:String = data.status;
        var responseData:Object = data.responseData;
        _isLoading = false;
        if (_devMode) {
            syncDeveloperFeatures();
        }

        if (status == SLTConfig.RESULT_SUCCEED) {
            var saltrFeatures:Dictionary;
            try {
                saltrFeatures = SLTDeserializer.decodeFeatures(responseData);
            } catch (e:Error) {
                //TODO: create wrapper error classes;
                _appDataLoadFailCallback(new SLTError(SLTError.CLIENT_FEATURES_PARSE_ERROR, "[SALTR] Failed to decode Features."));
                return;
            }

            try {
                _experiments = SLTDeserializer.decodeExperiments(responseData);
            } catch (e:Error) {
                _appDataLoadFailCallback(new SLTError(SLTError.CLIENT_EXPERIMENTS_PARSE_ERROR, "[SALTR] Failed to decode Experiments."));
                return;
            }

            try {
                _levelPacks = SLTDeserializer.decodeLevels(responseData);
            } catch (e:Error) {
                _appDataLoadFailCallback(new SLTError(SLTError.CLIENT_LEVELS_PARSE_ERROR, "[SALTR] Failed to decode Levels."));
                return;
            }

            _saltrUserId = responseData.saltrUserId;
            _connected = true;
            _repository.cacheObject(SLTConfig.APP_DATA_URL_CACHE, "0", responseData);

            _activeFeatures = saltrFeatures;
            _appDataLoadSuccessCallback();

            trace("[SALTR] AppData load success. LevelPacks loaded: " + _levelPacks.length);

            //TODO @GSAR: later we need to report the feature set differences by an event or a callback to client;
        }
        else {
            _appDataLoadFailCallback(new SLTError(responseData.errorCode, responseData.errorMessage));
        }
        resource.dispose();
    }

    private function syncDeveloperFeatures():void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = SLTConfig.COMMAND_SAVE_OR_UPDATE_FEATURE;
        urlVars.clientKey = _clientKey;
        if (_appVersion) {
            urlVars.appVersion = _appVersion;
        }
        var featureList:Array = [];
        for (var i:String in _developerFeatures) {
            var feature:SLTFeature = _developerFeatures[i];
            featureList.push({token: feature.token, value: JSON.stringify(feature.properties)});
        }
        urlVars.data = JSON.stringify(featureList);
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_URL, urlVars);
        var resource:SLTResource = new SLTResource("saveOrUpdateFeature", ticket, syncSuccessHandler, syncFailHandler);
        resource.load();
    }

    protected function syncSuccessHandler(resource:SLTResource):void {
        trace();
    }

    protected function syncFailHandler(resource:SLTResource):void {
    }

    private function getCachedLevelVersion(levelPack:SLTLevelPack, level:SLTLevel):String {
        var cachedFileName:String = Utils.formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectVersion(cachedFileName);
    }

    private function cacheLevelContentData(levelPack:SLTLevelPack, level:SLTLevel, contentData:Object):void {
        var cachedFileName:String = Utils.formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        _repository.cacheObject(cachedFileName, String(level.version), contentData);
    }

    private function loadLevelContentDataInternally(levelPack:SLTLevelPack, level:SLTLevel):Object {
        var contentData:Object = loadLevelContentFromCache(levelPack, level);
        if (contentData == null) {
            contentData = loadLevelContentFromDisk(levelPack, level);
        }
        return contentData;
    }

    private function loadLevelContentFromCache(levelPack:SLTLevelPack, level:SLTLevel):Object {
        var url:String = Utils.formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectFromCache(url);
    }

    private function loadLevelContentFromDisk(levelPack:SLTLevelPack, level:SLTLevel):Object {
        var url:String = Utils.formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_PACKAGE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectFromApplication(url);
    }

    //TODO:: @daal do we need this forceNoCache?
    protected function loadLevelContentFromSALTR(levelPack:SLTLevelPack, level:SLTLevel, forceNoCache:Boolean = false):void {
        var dataUrl:String = forceNoCache ? level.contentDataUrl + "?_time_=" + new Date().getTime() : level.contentDataUrl;
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(dataUrl);
        var resource:SLTResource = new SLTResource("saltr", ticket, loadSuccessCallback, loadFailedCallback);
        resource.load();

        //TODO @GSAR: get rid of nested functions!
        function loadSuccessCallback():void {
            var contentData:Object = resource.jsonData;
            if (contentData != null) {
                cacheLevelContentData(levelPack, level, contentData);
            }
            else {
                contentData = loadLevelContentDataInternally(levelPack, level);
            }

            if (contentData != null) {
                levelContentLoadSuccessHandler(level, contentData);
            }
            else {
                contentDataLoadFailedCallback();
            }
            resource.dispose();
        }

        function loadFailedCallback():void {
            var contentData:Object = loadLevelContentDataInternally(levelPack, level);
            levelContentLoadSuccessHandler(level, contentData);
            resource.dispose();
        }
    }

    protected function levelContentLoadSuccessHandler(level:SLTLevel, data:Object):void {
        level.updateContent(data);
        _levelContentLoadSuccessCallback();
    }

    protected function contentDataLoadFailedCallback():void {
        trace("[Saltr] ERROR: Level data is not loaded.");
        _levelContentLoadFailCallback();
    }

    private function createAppDataResource(appDataAssetLoadCompleteHandler:Function, appDataAssetLoadErrorHandler:Function):SLTResource {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = SLTConfig.COMMAND_APP_DATA;
        var args:Object = {};
        if (_device != null) {
            args.device = _device;
        }
        if (_partner != null) {
            args.partner = _partner;
        }
        args.clientKey = _clientKey;
        urlVars.arguments = JSON.stringify(args);
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_API_URL, urlVars);
        return new SLTResource("saltAppConfig", ticket, appDataAssetLoadCompleteHandler, appDataAssetLoadErrorHandler);
    }

    //TODO @GSAR: port this later when SALTR is ready
    private function addUserProperty(propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void {
//        var urlVars:URLVariables = new URLVariables();
//        urlVars.command = SLTConfig.COMMAND_ADD_PROPERTY;
//        var args:Object = {saltId: _saltrUserId};
//        var properties:Array = [];
//        for (var i:uint = 0; i < propertyNames.length; i++) {
//            var propertyName:String = propertyNames[i];
//            var propertyValue:* = propertyValues[i];
//            var operation:String = operations[i];
//            properties.push({key: propertyName, value: propertyValue, operation: operation});
//        }
//        args.properties = properties;
//        args.clientKey = _clientKey;
//        urlVars.arguments = JSON.stringify(args);
//
//        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_API_URL, urlVars);
//
//        var resource:SLTResource = new SLTResource("property", ticket,
//                function (resource:SLTResource):void {
//                    trace("getSaltLevelPacks : success");
//                    var data:Object = resource.jsonData;
//                    resource.dispose();
//                },
//                function (resource:SLTResource):void {
//                    trace("getSaltLevelPacks : error");
//                    resource.dispose();
//                });
//        resource.load();
    }

    public function set useNoLevels(value:Boolean):void {
        _useNoLevels = value;
    }

    public function set useNoFeatures(value:Boolean):void {
        _useNoFeatures = value;
    }
}
}
