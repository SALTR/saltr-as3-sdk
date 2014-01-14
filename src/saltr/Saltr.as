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

import saltr.assets.Asset;
import saltr.assets.URLTicket;
import saltr.storage.IStorage;
import saltr.storage.Storage;
import saltr.utils.formatString;

public class Saltr {

    public static const SALT_API_URL:String = "http://api.saltr.com/httpjson.action";
    public static const COMMAND_APPDATA:String = "APPDATA";
    public static const COMMAND_ADDPROP:String = "ADDPROP";

    //
    protected static const APP_DATA_URL_CACHE:String = "app_data_cache.json";
    protected static const APP_DATA_URL_INTERNAL:String = "saltr/app_data.json";
    protected static const LEVEL_DATA_URL_LOCAL_TEMPLATE:String = "saltr/pack_{0}/level_{1}.json";
    protected static const LEVEL_DATA_URL_CACHE_TEMPLATE:String = "pack_{0}_level_{1}.json";

    public static const PROPERTY_OPERATIONS_INCREMENT:String = "inc";
    public static const PROPERTY_OPERATIONS_SET:String = "set";

    protected static const RESULT_SUCCEED:String = "SUCCEED";
    protected static const RESULT_ERROR:String = "ERROR";

    protected var _storage:IStorage;
    protected var _saltUserId:String;
    protected var _isLoading:Boolean;
    protected var _ready:Boolean;
    protected var _partnerDTO:PartnerDTO;

    protected var _saltDecoder:Deserializer;
    protected var _instanceKey:String;
    protected var _features:Vector.<Feature>;
    protected var _levelPackStructures:Vector.<LevelPackStructure>;
    protected var _experiments:Vector.<Experiment>;
    protected var _deviceDTO:DeviceDTO;
    protected var _onGetAppDataSuccess:Function;
    protected var _onGetAppDataFail:Function;
    protected var _onGetLevelDataBodySuccess:Function;
    protected var _onGetLevelDataBodyFail:Function;
    protected var _cacheData : Boolean;

    /**
     *
     */
    public function Saltr(instanceKey:String, enableCache : Boolean = true) {
        _instanceKey = instanceKey;
        _saltDecoder = new Deserializer();
        _isLoading = false;
        _ready = false;
        if(enableCache) {
            _storage = new Storage();
        }
    }

    public function get ready():Boolean {
        return _ready;
    }

    public function getFeatureByToken(token:String):Feature {
        for each(var feature:Feature in _features) {
            if (feature.token == token) {
                return feature;
            }
        }
        return null;
    }

    public function initPartner(partnerId:String, partnerType:String):void {
        _partnerDTO = new PartnerDTO(partnerId, partnerType);
    }

    public function initDevice(deviceId:String, deviceType:String):void {
        _deviceDTO = new DeviceDTO(deviceId, deviceType);
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
        _saltDecoder.decode(jsonData);
        _features = _saltDecoder.features;
        _levelPackStructures = _saltDecoder.levelPackStructures;
        _experiments = _saltDecoder.experiments;
        trace("[SaltClient] packs=" + _saltDecoder.levelPackStructures.length);
        _onGetAppDataSuccess();
    }

    private function loadAppDataFailHandler():void {
        _isLoading = false;
        _ready = false;
        _onGetAppDataFail();
        trace("[SaltClient] ERROR: Level Packs are not loaded.");
    }

    protected function loadAppDataInternal():void {
        trace("[SaltClient] NO Internet available - so loading internal app data.");
        var data:Object = _storage.getObject(APP_DATA_URL_CACHE, Storage.FROM_CACHE);
        if (data != null) {
            trace("[SaltClient] Loading App data from Cache folder.");

            loadAppDataSuccessHandler(data);
        }
        else {
            trace("[SaltClient] Loading App data from application folder.");
            data = _storage.getObject(APP_DATA_URL_INTERNAL, Storage.FROM_APP);
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
        }

        //if there are no version change than load from cache
        var cachedFileName:String = formatString(LEVEL_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
        if (levelData.version == _storage.getObjectVersion(cachedFileName, Storage.FROM_CACHE)) {
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
        var data:Object = _storage.getObject(cachedFileName, Storage.FROM_CACHE);
        if (data != null) {
            levelLoadSuccessHandler(levelData, data);
            return true;
        }
        return false;
    }

    private function loadLevelDataInternal(levelPackData:LevelPackStructure, levelData:LevelStructure):void {
        var url:String = formatString(LEVEL_DATA_URL_LOCAL_TEMPLATE, levelPackData.index, levelData.index);
        var data:Object = _storage.getObject(url, Storage.FROM_APP);
        if (data != null) {
            levelLoadSuccessHandler(levelData, data);
        }
        else {
            levelLoadErrorHandler();
        }
    }

    protected function loadLevelDataFromServer(levelPackData:LevelPackStructure, levelData:LevelStructure, forceNoCache:Boolean = false):void {
        var dataUrl:String = forceNoCache ? levelData.dataUrl + "?_time_=" + new Date().getTime() : levelData.dataUrl;
        var ticket:URLTicket = new URLTicket(dataUrl);
        var asset:Asset = new Asset("saltr", ticket, levelDataAssetLoadedHandler, levelDataAssetLoadErrorHandler);
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
                _storage.cacheObject(cachedFileName, String(levelData.version), data);
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
    public function addProperty(saltUserId:String, saltInstanceKey:String, propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = Saltr.COMMAND_ADDPROP;
        var args:Object = {saltId: saltUserId};
        var properties:Array = [];
        for (var i:uint = 0; i < propertyNames.length; i++) {
            var propertyName:String = propertyNames[i];
            var propertyValue:* = propertyValues[i];
            var operation:String = operations[i];
            properties.push({key: propertyName, value: propertyValue, operation: operation});
        }
        args.properties = properties;
        args.instanceKey = saltInstanceKey;
        urlVars.arguments = JSON.stringify(args);

        var ticket:URLTicket = new URLTicket(Saltr.SALT_API_URL, urlVars);

        var asset:Asset = new Asset("property", ticket,
                function (asset:Asset):void {
                    trace("getSaltLevelPacks : success");
                    var data:Object = asset.jsonData;
                    asset.dispose();
                },
                function (asset:Asset):void {
                    trace("getSaltLevelPacks : error");
                    asset.dispose();
                });
        asset.load();
    }


    private function loadAppData():void {
        if (_isLoading) {
            return;
        }
        _isLoading = true;
        _ready = false;
        var asset:Asset = createAppDataAsset(appDataAssetLoadCompleteHandler, appDataAssetLoadErrorHandler);
        asset.load();
    }

    private function appDataAssetLoadErrorHandler(asset:Asset):void {
        trace("[SaltAPI] App data is failed to load.");
        loadAppDataInternal();
        asset.dispose();
    }

    private function appDataAssetLoadCompleteHandler(asset:Asset):void {
        trace("[SaltAPI] App data is loaded.");
        var data:Object = asset.jsonData;
        var jsonData:Object = data.responseData;
        trace("[SaltClient] Loaded App data. json=" + jsonData);
        if (jsonData == null || data["status"] != Saltr.RESULT_SUCCEED) {
            loadAppDataInternal();
        }
        else {
            loadAppDataSuccessHandler(jsonData);
            _storage.cacheObject(APP_DATA_URL_CACHE, "0", jsonData);
        }
        asset.dispose();
    }

    private function createAppDataAsset(appDataAssetLoadCompleteHandler:Function, appDataAssetLoadErrorHandler:Function):Asset {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = Saltr.COMMAND_APPDATA;
        var args:Object = {};
        if (_deviceDTO != null) {
            args.device = _deviceDTO;
        }
        if (_partnerDTO != null) {
            args.partner = _partnerDTO;
        }
        args.instanceKey = _instanceKey;
        urlVars.arguments = JSON.stringify(args);
        var ticket:URLTicket = new URLTicket(Saltr.SALT_API_URL, urlVars);
        return new Asset("saltAppConfig", ticket, appDataAssetLoadCompleteHandler, appDataAssetLoadErrorHandler);
    }

    public function get features():Vector.<Feature> {
        return _features;
    }

    public function get levelPackStructures():Vector.<LevelPackStructure> {
        return _levelPackStructures;
    }

    public function get experiments():Vector.<Experiment> {
        return _experiments;
    }
}
}
