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
    protected var _onDataLoadSuccess:Function;
    protected var _onDataLoadFail:Function;
    protected var _onGetLevelDataBodySuccess:Function;
    protected var _onGetLevelDataBodyFail:Function;

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
        path = path == null ? SLTConfig.LEVEL_PACK_URL_LOCAL : path;
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
        _onDataLoadSuccess = onDataLoadSuccess;
        _onDataLoadFail = onDataLoadFail;
        applyCachedFeatures();

        _isLoading = true;
        _connected = false;
        var resource:SLTResource = createDataResource(resourceLoadSuccessHandler, resourceLoadFailHandler);
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

    protected function loadDataSuccessHandler(jsonData:Object):void {
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
        _onDataLoadSuccess();

        //TODO @GSAR: implement this!
        if (_isInDevMode) {
            syncFeatures();
        }
    }

    private function loadDataFailHandler():void {
        _isLoading = false;
        _connected = false;
        _onDataLoadFail();
        trace("[Saltr] ERROR: Level Packs are not loaded.");
    }

    public function getLevelDataBody(levelPackData:SLTLevelPack, levelData:SLTLevel, onGetLevelDataBodySuccess:Function, onGetLevelDataBodyFail:Function, useCache:Boolean = true):void {
        _onGetLevelDataBodySuccess = onGetLevelDataBodySuccess;
        _onGetLevelDataBodyFail = onGetLevelDataBodyFail;
        if (!useCache) {
            loadLevelDataFromServer(levelPackData, levelData, true);
            return;
        }

        //if there are no version change than load from cache
        var cachedFileName:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
        if (levelData.version == _repository.getObjectVersion(cachedFileName)) {
            loadLevelDataCached(levelData, cachedFileName);
        } else {
            loadLevelDataFromServer(levelPackData, levelData);
        }
    }

    protected function levelLoadSuccessHandler(level:SLTLevel, data:Object):void {
        level.updateContent(data);
        _onGetLevelDataBodySuccess();
    }

    protected function levelLoadErrorHandler():void {
        trace("[Saltr] ERROR: Level data is not loaded.");
        _onGetLevelDataBodyFail();
    }

    protected function loadLevelDataLocally(levelPackData:SLTLevelPack, levelData:SLTLevel, cachedFileName:String):void {
        if (loadLevelDataCached(levelData, cachedFileName) == true) {
            return;
        }
        loadLevelDataInternal(levelPackData, levelData);
    }

    protected function loadLevelDataCached(levelData:SLTLevel, cachedFileName:String):Boolean {
        trace("[SaltClient::loadLevelData] LOADING LEVEL DATA CACHE IMMEDIATELY.");
        var data:Object = _repository.getObjectFromCache(cachedFileName);
        if (data != null) {
            levelLoadSuccessHandler(levelData, data);
            return true;
        }
        return false;
    }

    private function loadLevelDataInternal(levelPackData:SLTLevelPack, levelData:SLTLevel):void {
        var url:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_LOCAL_TEMPLATE, levelPackData.index, levelData.index);
        var data:Object = _repository.getObjectFromApplication(url);
        if (data != null) {
            levelLoadSuccessHandler(levelData, data);
        }
        else {
            levelLoadErrorHandler();
        }
    }

    protected function loadLevelDataFromServer(levelPackData:SLTLevelPack, levelData:SLTLevel, forceNoCache:Boolean = false):void {
        var dataUrl:String = forceNoCache ? levelData.contentDataUrl + "?_time_=" + new Date().getTime() : levelData.contentDataUrl;
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(dataUrl);
        var asset:SLTResource = new SLTResource("saltr", ticket, levelDataAssetLoadedHandler, levelDataAssetLoadErrorHandler);
        asset.load();
        //
        //TODO @GSAR: get rid of nested functions!
        function levelDataAssetLoadedHandler():void {
            var data:Object = asset.jsonData;
            var cachedFileName:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
            if (asset.jsonData == null) {
                loadLevelDataLocally(levelPackData, levelData, cachedFileName);
            }
            else {
                levelLoadSuccessHandler(levelData, data);
                _repository.cacheObject(cachedFileName, String(levelData.version), data);
            }
            asset.dispose();
        }

        function levelDataAssetLoadErrorHandler():void {
            var cachedFileName:String = formatString(SLTConfig.LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
            loadLevelDataLocally(levelPackData, levelData, cachedFileName);
            asset.dispose();
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

    private function resourceLoadFailHandler(resource:SLTResource):void {
        trace("[Saltr] App data is failed to load.");
        loadDataFailHandler();
        resource.dispose();
    }

    private function resourceLoadSuccessHandler(resource:SLTResource):void {
        var data:Object = resource.jsonData;
        var jsonData:Object = data.responseData;
        trace("[Saltr] Loaded App data. json=" + jsonData);
        loadDataSuccessHandler(jsonData);
        _repository.cacheObject(SLTConfig.APP_DATA_URL_CACHE, "0", jsonData);
        resource.dispose();
    }

    private function createDataResource(appDataAssetLoadCompleteHandler:Function, appDataAssetLoadErrorHandler:Function):SLTResource {
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
        var resource:SLTResource = new SLTResource("saveOrUpdateFeature", ticket, syncSuccessHandler, syncFailHandler);
        resource.load();
    }

    protected function syncSuccessHandler(resource:SLTResource):void {}

    protected function syncFailHandler(resource:SLTResource):void {}
}
}
