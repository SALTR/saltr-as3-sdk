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
import saltr.repository.SLTMobileRepository;
import saltr.resource.SLTResource;
import saltr.resource.SLTResourceURLTicket;
import saltr.utils.formatString;

//TODO:: @daal add some flushCache method.
public class SLTSaltrMobile {

    protected var _repository:ISLTRepository;
    protected var _saltrUserId:String;
    protected var _isLoading:Boolean;
    protected var _connected:Boolean;
    protected var _partner:SLTPartner;

    protected var _deserializer:SLTDeserializer;
    protected var _instanceKey:String;
    protected var _features:Dictionary;
    protected var _levelPacks:Vector.<SLTLevelPack>;
    protected var _experiments:Vector.<SLTExperiment>;
    protected var _device:SLTDevice;
    protected var _onAppDataLoadSuccess:Function;
    protected var _onAppDataLoadFail:Function;
    protected var _onContentDataLoadSuccess:Function;
    protected var _onContentDataFail:Function;

    private var _isInDevMode:Boolean;
    private var _appVersion : String;


    //TODO @GSAR: clean up all classes method order - to give SDK a representative look!
    public function SLTSaltrMobile(instanceKey:String) {
        _instanceKey = instanceKey;
        _isLoading = false;
        _connected = false;

        //TODO @GSAR: implement usage of dev mode variable
        _isInDevMode = true;
        _features = new Dictionary();
        _deserializer = new SLTDeserializer();
        _repository = new SLTMobileRepository();
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

    public function getFeature(token:String):SLTFeature {
        return _features[token];
    }

    public function initPartner(partnerId:String, partnerType:String):void {
        _partner = new SLTPartner(partnerId, partnerType);
    }

    public function initDevice(deviceId:String, deviceType:String):void {
        _device = new SLTDevice(deviceId, deviceType);
    }

    public function importLevels(path : String = null) : void {
        path = path == null ? SLTConfig.LEVEL_PACK_URL_PACKAGE : path;
        var applicationData:Object = _repository.getObjectFromApplication(path);
        _levelPacks = _deserializer.decodeLevels(applicationData);
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

    public function start(onDataLoadSuccess:Function, onDataLoadFail:Function):void {
        if (_isLoading) {
            return;
        }
        _onAppDataLoadSuccess = onDataLoadSuccess;
        _onAppDataLoadFail = onDataLoadFail;
        applyCachedFeatures();

        _isLoading = true;
        _connected = false;
        var resource:SLTResource = createAppDataResource(appDataLoadCompleteCallback, appDataLoadFailedCallback);
        resource.load();
    }

    private function applyCachedFeatures():void {
        var cachedData:Object = _repository.getObjectFromCache(SLTConfig.APP_DATA_URL_CACHE);
        var cachedFeatures:Dictionary = _deserializer.decodeFeatures(cachedData);
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
    public function addUserProperty(propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = SLTConfig.COMMAND_ADD_PROPERTY;
        var args:Object = {saltId: _saltrUserId};
        var properties:Array = [];
        for (var i:uint = 0; i < propertyNames.length; i++) {
            var propertyName:String = propertyNames[i];
            var propertyValue:* = propertyValues[i];
            var operation:String = operations[i];
            properties.push({key: propertyName, value: propertyValue, operation: operation});
        }
        args.properties = properties;
        args.instanceKey = _instanceKey;
        urlVars.arguments = JSON.stringify(args);

        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_API_URL, urlVars);

        var resource:SLTResource = new SLTResource("property", ticket,
                function (resource:SLTResource):void {
                    trace("getSaltLevelPacks : success");
                    var data:Object = resource.jsonData;
                    resource.dispose();
                },
                function (resource:SLTResource):void {
                    trace("getSaltLevelPacks : error");
                    resource.dispose();
                });
        resource.load();
    }

    private function appDataLoadFailedCallback(resource:SLTResource):void {
        trace("[Saltr] App data is failed to load.");
        resource.dispose();
        _isLoading = false;
        _connected = false;
        _onAppDataLoadFail();
    }

    //TODO:: @daal. Error case should be handled. if resource.jsonData contains any error from salt.
    private function appDataLoadCompleteCallback(resource:SLTResource):void {
        var data:Object = resource.jsonData;
        var jsonData:Object = data.responseData;
        _repository.cacheObject(SLTConfig.APP_DATA_URL_CACHE, "0", jsonData);
        resource.dispose();
        _isLoading = false;
        _connected = true;

        //TODO @GSAR: rename jsonData.saltId to jsonData.saltrUserId
        _saltrUserId = jsonData.saltId;

        _experiments = _deserializer.decodeExperiments(jsonData);
        _levelPacks = _deserializer.decodeLevels(jsonData);
        var saltrFeatures:Dictionary = _deserializer.decodeFeatures(jsonData);

        //merging with defaults...
        for (var token:String in saltrFeatures) {
            var saltrFeature:SLTFeature = saltrFeatures[token];
            var defaultFeature:SLTFeature = _features[token];
            if (defaultFeature != null) {
                saltrFeature.defaultProperties = defaultFeature.defaultProperties;
            }
            _features[token] = saltrFeature;
        }

        trace("[Saltr] packs=" + _levelPacks.length);
        _onAppDataLoadSuccess();

        //TODO @GSAR: implement this!
        if (_isInDevMode) {
            syncFeatures();
        }
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
        args.instanceKey = _instanceKey;
        urlVars.arguments = JSON.stringify(args);
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_API_URL, urlVars);
        return new SLTResource("saltAppConfig", ticket, appDataAssetLoadCompleteHandler, appDataAssetLoadErrorHandler);
    }

    private function syncFeatures():void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = SLTConfig.COMMAND_SAVE_OR_UPDATE_FEATURE;
        urlVars.instanceKey = _instanceKey;
        if(_appVersion) {
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

    protected function syncSuccessCallback(resource:SLTResource):void {}
    protected function syncFailCallback(resource:SLTResource):void {}


    /////////////////////////////////////// level content data loading methods.

    public function loadLevelContentData(levelPack:SLTLevelPack, level:SLTLevel, successCallback:Function, failCallback:Function, useCache:Boolean = true):void {
        _onContentDataLoadSuccess = successCallback;
        _onContentDataFail = failCallback;
        if (!useCache) {
            loadLevelContentDataFromSaltr(levelPack, level, true);
        }
        else {
            //if there are no version change than load from cache
            var cachedVersion : String = getCachedLevelVersion(levelPack, level);
            if (level.version == cachedVersion) {
                var contentData = loadLevelContentDataFromCache(levelPack, level);
                levelLoadSuccessHandler(level, contentData);
            }
            else {
                loadLevelContentDataFromSaltr(levelPack, level);
            }
        }
    }

    private function getCachedLevelVersion(levelPack : SLTLevelPack, level : SLTLevel) : String {
        var cachedFileName:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectVersion(cachedFileName);
    }

    private function cacheLevelContentData(levelPack:SLTLevelPack, level:SLTLevel, contentData : Object):void {
        var cachedFileName:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        _repository.cacheObject(cachedFileName, String(level.version), contentData);
    }

    private function loadLevelContentDataFromInternalStorage(levelPack : SLTLevelPack, level : SLTLevel) : Object {
        var contentData = loadLevelContentDataFromCache(levelPack, level);
        if(contentData == null) {
            contentData = loadLevelContentDataFromPackage(levelPack, level);
        }
        return contentData;
    }

    private function loadLevelContentDataFromCache(levelPack : SLTLevelPack, level : SLTLevel) : Object {
        var url : String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectFromCache(url);
    }
    private function loadLevelContentDataFromPackage(levelPack : SLTLevelPack, level : SLTLevel) : Object {
        var url:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_PACKAGE_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectFromApplication(url);
    }

    //TODO:: @daal do we need this forceNoCache?
    protected function loadLevelContentDataFromSaltr(levelPack:SLTLevelPack, level:SLTLevel, forceNoCache:Boolean = false):void {
        var dataUrl:String = forceNoCache ? level.contentDataUrl + "?_time_=" + new Date().getTime() : level.contentDataUrl;
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(dataUrl);
        var resource:SLTResource = new SLTResource("saltr", ticket, contentDataLoadedCallback, contentDataLoadFailedCallback);
        resource.load();
        //
        //TODO @GSAR: get rid of nested functions!
        function contentDataLoadedCallback():void {
            var contentData:Object = resource.jsonData;
            if(contentData != null) {
                cacheLevelContentData(levelPack, level, contentData);
            }
            else {
                contentData = loadLevelContentDataFromInternalStorage(levelPack, level);
            }

            if(contentData != null) {
                levelLoadSuccessHandler(level, contentData);
            }
            else {
                levelLoadErrorHandler();
            }
            resource.dispose();
        }

        function contentDataLoadFailedCallback():void {
            var contentData : Object = loadLevelContentDataFromInternalStorage(levelPack, level);
            levelLoadSuccessHandler(level, contentData);
            resource.dispose();
        }
    }

    protected function levelLoadSuccessHandler(level:SLTLevel, data:Object):void {
        level.updateContent(data);
        _onContentDataLoadSuccess();
    }

    protected function levelLoadErrorHandler():void {
        trace("[Saltr] ERROR: Level data is not loaded.");
        _onContentDataFail();
    }
}
}
