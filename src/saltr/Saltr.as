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

import saltr.repository.IRepository;
import saltr.resource.Resource;
import saltr.resource.ResourceURLTicket;
import saltr.utils.formatString;

//TODO:: @daal add some flushCache method.
public class Saltr {

    protected static const SALTR_API_URL:String = "http://api.saltr.com/httpjson.action";
    protected static const SALTR_URL:String = "http://saltr.com/httpjson.action";
    protected static const COMMAND_APP_DATA:String = "APPDATA";
    protected static const COMMAND_ADD_PROPERTY:String = "ADDPROP";
    protected static const COMMAND_SAVE_OR_UPDATE_FEATURE:String = "SOUFTR";

    //
    protected static const APP_DATA_URL_CACHE:String = "app_data_cache.json";
    protected static const APP_DATA_URL_INTERNAL:String = "saltr/app_data.json";
    protected static const LEVEL_DATA_URL_LOCAL_TEMPLATE:String = "saltr/pack_{0}/level_{1}.json";
    protected static const LEVEL_DATA_URL_CACHE_TEMPLATE:String = "pack_{0}_level_{1}.json";

    public static const PROPERTY_OPERATIONS_INCREMENT:String = "inc";
    public static const PROPERTY_OPERATIONS_SET:String = "set";

    protected static const RESULT_SUCCEED:String = "SUCCEED";
    protected static const RESULT_ERROR:String = "ERROR";

    protected var _repository:IRepository;
    protected var _saltUserId:String;
    protected var _isLoading:Boolean;
    protected var _ready:Boolean;
    protected var _partner:Partner;

    protected var _deserializer:Deserializer;
    protected var _instanceKey:String;
    protected var _features:Dictionary;
    protected var _levelPackStructures:Vector.<LevelPackStructure>;
    protected var _experiments:Vector.<Experiment>;
    protected var _device:Device;
    protected var _onGetAppDataSuccess:Function;
    protected var _onGetAppDataFail:Function;
    protected var _onGetLevelDataBodySuccess:Function;
    protected var _onGetLevelDataBodyFail:Function;

    private var _isInDevMode:Boolean;
    private var _appVersion : String;


    //TODO @GSAR: clean up all classes method order - to give SDK a representative look!
    public function Saltr(instanceKey:String) {
        _features = new Dictionary();
        _instanceKey = instanceKey;
        _deserializer = new Deserializer();
        _isLoading = false;
        _ready = false;
        _isInDevMode = true;
    }

    public function set appVersion(value:String):void {
        _appVersion = value;
    }

    public function set repository(value:IRepository):void {
        _repository = value;
    }

    public function get ready():Boolean {
        return _ready;
    }

    public function get features():Dictionary {
        return _features;
    }

    public function get levelPackStructures():Vector.<LevelPackStructure> {
        return _levelPackStructures;
    }

    public function get experiments():Vector.<Experiment> {
        return _experiments;
    }

    public function getFeature(token:String):Feature {
        return _features[token];
    }

    public function initPartner(partnerId:String, partnerType:String):void {
        _partner = new Partner(partnerId, partnerType);
    }

    public function initDevice(deviceId:String, deviceType:String):void {
        _device = new Device(deviceId, deviceType);
    }

    /**
     * If you want to have a feature synced with SALTR you should call define before getAppData call.
     */
    public function defineFeature(token:String, properties:Object):void {
        var feature:Feature = _features[token];
        if (feature == null) {
            _features[token] = new Feature(token, null, properties);
        }
        else {
            feature.defaultProperties = properties;
        }
    }

    public function getAppData(onGetAppDataSuccess:Function, onGetAppDataFail:Function):void {
        _onGetAppDataSuccess = onGetAppDataSuccess;
        _onGetAppDataFail = onGetAppDataFail;
        loadAppData();
    }

    protected function loadAppDataSuccessHandler(jsonData:Object):void {
        _isLoading = false;
        _ready = true;
        _saltUserId = jsonData.saltId;

        _experiments = _deserializer.decodeExperiments(jsonData);
        _levelPackStructures = _deserializer.decodeLevels(jsonData);
        var saltrFeatures:Dictionary = _deserializer.decodeFeatures(jsonData);
        //merging with defaults...
        for (var i:String in saltrFeatures) {
            var saltrFeature:Feature = saltrFeatures[i];
            var defaultFeature:Feature = _features[i];
            if (defaultFeature != null) {
                saltrFeature.defaultProperties = defaultFeature.defaultProperties;
            }
            _features[i] = saltrFeature;
        }

        trace("[SaltClient] packs=" + _levelPackStructures.length);
        _onGetAppDataSuccess();

        if (_isInDevMode) {
            syncFeatures();
        }
    }

    private function loadAppDataFailHandler():void {
        _isLoading = false;
        _ready = false;
        _onGetAppDataFail();
        trace("[SaltClient] ERROR: Level Packs are not loaded.");
    }

    protected function loadAppDataInternal():void {
        trace("[SaltClient] NO Internet available - so loading internal app data.");
        var data:Object = _repository.getObjectFromCache(APP_DATA_URL_CACHE);
        if (data != null) {
            trace("[SaltClient] Loading App data from Cache folder.");

            loadAppDataSuccessHandler(data);
        }
        else {
            trace("[SaltClient] Loading App data from application folder.");
            data = _repository.getObjectFromApplication(APP_DATA_URL_INTERNAL);
            if (data != null) {
                loadAppDataSuccessHandler(data);
            }
            else {
                loadAppDataFailHandler();
            }

        }
    }

    /////////////////////////////////////

    public function getLevelDataBody(levelPackData:LevelPackStructure, levelData:LevelStructure, onGetLevelDataBodySuccess:Function, onGetLevelDataBodyFail:Function, useCache:Boolean = true):void {
        _onGetLevelDataBodySuccess = onGetLevelDataBodySuccess;
        _onGetLevelDataBodyFail = onGetLevelDataBodyFail;
        if (!useCache) {
            loadLevelDataFromServer(levelPackData, levelData, true);
            return;
        }

        //if there are no version change than load from cache
        var cachedFileName:String = formatString(LEVEL_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
        if (levelData.version == _repository.getObjectVersion(cachedFileName)) {
            loadLevelDataCached(levelData, cachedFileName);
        } else {
            loadLevelDataFromServer(levelPackData, levelData);
        }

    }

    protected function levelLoadSuccessHandler(levelData:LevelStructure, data:Object):void {
        levelData.parseData(data);
        _onGetLevelDataBodySuccess();
    }

    protected function levelLoadErrorHandler():void {
        trace("[SaltClient] ERROR: Level data is not loaded.");
        _onGetLevelDataBodyFail();
    }

    protected function loadLevelDataLocally(levelPackData:LevelPackStructure, levelData:LevelStructure, cachedFileName:String):void {
        if (loadLevelDataCached(levelData, cachedFileName) == true) {
            return;
        }
        loadLevelDataInternal(levelPackData, levelData);
    }

    protected function loadLevelDataCached(levelData:LevelStructure, cachedFileName:String):Boolean {
        trace("[SaltClient::loadLevelData] LOADING LEVEL DATA CACHE IMMEDIATELY.");
        var data:Object = _repository.getObjectFromCache(cachedFileName);
        if (data != null) {
            levelLoadSuccessHandler(levelData, data);
            return true;
        }
        return false;
    }

    private function loadLevelDataInternal(levelPackData:LevelPackStructure, levelData:LevelStructure):void {
        var url:String = formatString(LEVEL_DATA_URL_LOCAL_TEMPLATE, levelPackData.index, levelData.index);
        var data:Object = _repository.getObjectFromApplication(url);
        if (data != null) {
            levelLoadSuccessHandler(levelData, data);
        }
        else {
            levelLoadErrorHandler();
        }
    }

    protected function loadLevelDataFromServer(levelPackData:LevelPackStructure, levelData:LevelStructure, forceNoCache:Boolean = false):void {
        var dataUrl:String = forceNoCache ? levelData.dataUrl + "?_time_=" + new Date().getTime() : levelData.dataUrl;
        var ticket:ResourceURLTicket = new ResourceURLTicket(dataUrl);
        var asset:Resource = new Resource("saltr", ticket, levelDataAssetLoadedHandler, levelDataAssetLoadErrorHandler);
        asset.load();
        //
        //TODO @GSAR: get rid of nested functions!
        function levelDataAssetLoadedHandler():void {
            var data:Object = asset.jsonData;
            var cachedFileName:String = formatString(LEVEL_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
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
            var cachedFileName:String = formatString(LEVEL_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
            loadLevelDataLocally(levelPackData, levelData, cachedFileName);
            asset.dispose();
        }
    }


    //TODO @GSAR: port this later when SALTR is ready
    public function addUserProperty(propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = Saltr.COMMAND_ADD_PROPERTY;
        var args:Object = {saltId: _saltUserId};
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

        var ticket:ResourceURLTicket = new ResourceURLTicket(Saltr.SALTR_API_URL, urlVars);

        var resource:Resource = new Resource("property", ticket,
                function (resource:Resource):void {
                    trace("getSaltLevelPacks : success");
                    var data:Object = resource.jsonData;
                    resource.dispose();
                },
                function (resource:Resource):void {
                    trace("getSaltLevelPacks : error");
                    resource.dispose();
                });
        resource.load();
    }

    private function loadAppData():void {
        if (_isLoading) {
            return;
        }
        _isLoading = true;
        _ready = false;
        var asset:Resource = createAppDataResource(appDataAssetLoadCompleteHandler, appDataAssetLoadErrorHandler);
        asset.load();
    }

    private function appDataAssetLoadErrorHandler(asset:Resource):void {
        trace("[SaltAPI] App data is failed to load.");
        loadAppDataInternal();
        asset.dispose();
    }

    private function appDataAssetLoadCompleteHandler(asset:Resource):void {
        trace("[SaltAPI] App data is loaded.");
        var data:Object = asset.jsonData;
        var jsonData:Object = data.responseData;
        trace("[SaltClient] Loaded App data. json=" + jsonData);
        if (jsonData == null || data["status"] != Saltr.RESULT_SUCCEED) {
            loadAppDataInternal();
        }
        else {
            loadAppDataSuccessHandler(jsonData);
            _repository.cacheObject(APP_DATA_URL_CACHE, "0", jsonData);
        }
        asset.dispose();
    }

    private function createAppDataResource(appDataAssetLoadCompleteHandler:Function, appDataAssetLoadErrorHandler:Function):Resource {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = Saltr.COMMAND_APP_DATA;
        var args:Object = {};
        if (_device != null) {
            args.device = _device;
        }
        if (_partner != null) {
            args.partner = _partner;
        }
        args.instanceKey = _instanceKey;
        urlVars.arguments = JSON.stringify(args);
        var ticket:ResourceURLTicket = new ResourceURLTicket(Saltr.SALTR_API_URL, urlVars);
        return new Resource("saltAppConfig", ticket, appDataAssetLoadCompleteHandler, appDataAssetLoadErrorHandler);
    }

    private function syncFeatures():void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = Saltr.COMMAND_SAVE_OR_UPDATE_FEATURE;
        urlVars.instanceKey = _instanceKey;
        if(_appVersion) {
            urlVars.appVersion = _appVersion;
        }
        var featureList:Array = [];
        for (var i:String in _features) {
            var feature:Feature = _features[i];
            if (feature.defaultProperties != null) {
                featureList.push({token: feature.token, value: JSON.stringify(feature.defaultProperties)});
            }
        }
        urlVars.data = JSON.stringify(featureList);
        var ticket:ResourceURLTicket = new ResourceURLTicket(Saltr.SALTR_URL, urlVars);
        var resource:Resource = new Resource("saveOrUpdateFeature", ticket, syncSuccessHandler, syncFailHandler);
        resource.load();
    }

    protected function syncSuccessHandler(resource:Resource):void {}

    protected function syncFailHandler(resource:Resource):void {}
}
}
