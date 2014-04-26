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
import saltr.utils.formatString;

//TODO:: @daal add some flushCache method.
public class SLTSaltrMobile {

    protected var _partner:SLTPartner;
    protected var _device:SLTDevice;
    protected var _connected:Boolean;
    protected var _clientKey:String;
    protected var _saltrUserId:String;
    protected var _isLoading:Boolean;

    protected var _repository:ISLTRepository;
    protected var _features:Dictionary;
    protected var _levelPacks:Vector.<SLTLevelPack>;
    protected var _experiments:Vector.<SLTExperiment>;

    protected var _appDataLoadSuccessCallback:Function;
    protected var _appDataLoadFailCallback:Function;
    protected var _levelContentLoadSuccessCallback:Function;
    protected var _levelContentLoadFailCallback:Function;

    private var _devMode:Boolean;
    private var _appVersion:String;


    //TODO @GSAR: clean up all classes method order - to give SDK a representative look!
    public function SLTSaltrMobile(clientKey:String, useCache:Boolean = true) {
        _clientKey = clientKey;
        _isLoading = false;
        _connected = false;

        //TODO @GSAR: implement usage of dev mode variable
        _devMode = true;
        _features = new Dictionary();
        _experiments = new <SLTExperiment>[];

        _repository = useCache ? new SLTMobileRepository() : new SLTDummyRepository();
    }

    public function set appVersion(value:String):void {
        _appVersion = value;
    }

    public function set repository(value:ISLTRepository):void {
        _repository = value;
    }

    public function get connected():Boolean {
        return _connected;
    }

    public function get features():Dictionary {
        return _features;
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

    public function getFeature(token:String):SLTFeature {
        return _features[token];
    }

    public function importLevels(path:String = null):void {
        path = path == null ? SLTConfig.LEVEL_PACK_URL_PACKAGE : path;
        var applicationData:Object = _repository.getObjectFromApplication(path);
        _levelPacks = SLTDeserializer.decodeLevels(applicationData);
    }

    /**
     * If you want to have a feature synced with SALTR you should call define before getAppData call.
     */
        //TODO @GSAR: add Properties class to handle correct feature properties assignment
    public function defineFeature(token:String, properties:Object):void {
        var feature:SLTFeature = _features[token];
        if (feature == null) {
            _features[token] = new SLTFeature(token, null, properties);
        }
        else {
            feature.defaultProperties = properties;
        }
    }

    public function connect(loadSuccessCallback:Function, loadFailCallback:Function):void {
        if (_isLoading) {
            return;
        }
        _appDataLoadSuccessCallback = loadSuccessCallback;
        _appDataLoadFailCallback = loadFailCallback;
        loadCachedFeatures();

        _isLoading = true;
        _connected = false;
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

    private function loadCachedFeatures():void {
        var cachedData:Object = _repository.getObjectFromCache(SLTConfig.APP_DATA_URL_CACHE);
        if (cachedData == null) {
            return;
        }
        var cachedFeatures:Dictionary = SLTDeserializer.decodeFeatures(cachedData);
        for (var token:String in cachedFeatures) {
            var saltrFeature:SLTFeature = cachedFeatures[token];
            var defaultFeature:SLTFeature = _features[token];
            if (defaultFeature != null) {
                saltrFeature.defaultProperties = defaultFeature.defaultProperties;
            }
            _features[token] = saltrFeature;
        }
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

    private function appDataLoadFailHandler(resource:SLTResource):void {
        trace("[Saltr] App data is failed to load.");
        resource.dispose();
        _isLoading = false;
        _connected = false;
        _appDataLoadFailCallback(new SLTError(SLTError.GENERAL_ERROR_CODE, "[SALTR] Failed to load appData."));
    }

    private function appDataLoadSuccessHandler(resource:SLTResource):void {
        var data:Object = resource.jsonData;
        var status:String = data.status;
        var responseData:Object = data.responseData;
        _isLoading = false;
        if (status == SLTConfig.RESULT_SUCCEED) {
            _repository.cacheObject(SLTConfig.APP_DATA_URL_CACHE, "0", responseData);
            _connected = true;

            //TODO @daal. supporting saltId(old) and saltrUserId.
            _saltrUserId = responseData.hasOwnProperty("saltrUserId") ? responseData.saltrUserId : responseData.saltId;

            var saltrFeatures:Dictionary;

            try {
                saltrFeatures = SLTDeserializer.decodeFeatures(responseData);
            } catch (e:Error) {
                throw new Error("[SALTR] Failed to decode Features.");
            }

            try {
                _experiments = SLTDeserializer.decodeExperiments(responseData);
            } catch (e:Error) {
                throw new Error("[SALTR] Failed to decode Experiments.");
            }

            try {
                _levelPacks = SLTDeserializer.decodeLevels(responseData);
            } catch (e:Error) {
                throw new Error("[SALTR] Failed to decode Levels.");
            }

            //merging with defaults...
            for (var token:String in saltrFeatures) {
                var saltrFeature:SLTFeature = saltrFeatures[token];
                var defaultFeature:SLTFeature = _features[token];
                if (defaultFeature != null) {
                    //TODO: @GSAR - why this assigning is not opposite?
                    saltrFeature.defaultProperties = defaultFeature.defaultProperties;
                }
                _features[token] = saltrFeature;
            }

            trace("[SALTR] AppData load success. LevelPacks loaded: " + _levelPacks.length);
            _appDataLoadSuccessCallback();

            if (_devMode) {
                syncFeatures();
            }
        }
        else {
            _connected = false;
            _appDataLoadFailCallback(new SLTError(responseData.errorCode, responseData.errorMessage));
        }
        resource.dispose();
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

    private function syncFeatures():void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = SLTConfig.COMMAND_SAVE_OR_UPDATE_FEATURE;
        urlVars.clientKey = _clientKey;
        if (_appVersion) {
            urlVars.appVersion = _appVersion;
        }
        var featureList:Array = [];
        for (var i:String in _features) {
            var feature:SLTFeature = _features[i];
            if (feature.defaultProperties != null) {
                featureList.push({token: feature.token, value: JSON.stringify(feature.defaultProperties)});
            }
        }
        urlVars.data = JSON.stringify(featureList);
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_URL, urlVars);
        var resource:SLTResource = new SLTResource("saveOrUpdateFeature", ticket, syncSuccessCallback, syncFailCallback);
        resource.load();
    }

    protected function syncSuccessCallback(resource:SLTResource):void {
    }

    protected function syncFailCallback(resource:SLTResource):void {
    }

    private function getCachedLevelVersion(levelPack:SLTLevelPack, level:SLTLevel):String {
        var cachedFileName:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectVersion(cachedFileName);
    }

    private function cacheLevelContentData(levelPack:SLTLevelPack, level:SLTLevel, contentData:Object):void {
        var cachedFileName:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
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
        var url:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectFromCache(url);
    }

    private function loadLevelContentFromDisk(levelPack:SLTLevelPack, level:SLTLevel):Object {
        var url:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_PACKAGE_TEMPLATE, levelPack.index, level.index);
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
}
}
