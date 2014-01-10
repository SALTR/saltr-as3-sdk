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
package plexonic.saltr {
import plexonic.asset.Asset;
import plexonic.asset.JSONAsset;
import plexonic.asset.URLTicket;
import plexonic.error.PureVirtualFunctionError;
import plexonic.saltr.LevelPackStructure;
import plexonic.saltr.LevelStructure;
import plexonic.user.User;
import plexonic.util.Storage;

import starling.events.Event;
import starling.events.EventDispatcher;
import starling.utils.formatString;

public class Saltr extends EventDispatcher {
    public static const EVENT_LEVELDATA_READY:String = "levelDataReady";
    public static const EVENT_APPDATA_READY_FOR_SETTING:String = "appDataReadyForSetting";
    public static const EVENT_APPDATA_READY_FOR_USE:String = "appDataReadyForUse";

    public static const PLATFORM_TYPE_IOS:String = "iOS";
    public static const PLATFORM_TYPE_WEB:String = "web";
    public static const SALT_API_URL:String = CONFIG::saltApiUrl;
    public static const COMMAND_GAFE:String = "GAFE";
    public static const COMMAND_EXPG:String = "EXPG";
    public static const COMMAND_APPDATA:String = "APPDATA";
    public static const COMMAND_ADDPROP:String = "ADDPROP";

    //
    protected static const PACKS_DATA_URL_CACHE:String = "level_packs_cache.json";
    protected static const PACKS_DATA_URL_INTERNAL:String = "level/level_packs.json";
    protected static const LEVEL_DATA_URL_LOCAL_TEMPLATE:String = "level/pack_{0}/level_{1}.json";
    private static const LEVEL_DATA_URL_CACHE_TEMPLATE:String = "pack_{0}_level_{1}.json";

    public static const PROPERTY_OPERATIONS_INCREMENT:String = "inc";
    public static const PROPERTY_OPERATIONS_SET:String = "set";

    protected static const RESULT_SUCCEED:String = "SUCCEED";
    private static const RESULT_ERROR:String = "ERROR";

    protected var _storage:Storage;
    protected var _api:ISaltrAPI;
    protected var _saltUserId:String;
    protected var _isLoading:Boolean;
    protected var _ready:Boolean;
    protected var _partnerDTO:SaltrPartnerDTO;

    private var _saltDecoder:SaltrDecoder;
    protected var _instanceKey:String;

    /**
     *
     */
    public function Saltr() {

    }

    // TODO: override init in WebSaltr
    public function init(instanceKey:String):void {
        _storage = Storage.getInstance();
        _instanceKey = instanceKey;
        _api = new SaltrAPI();
        _saltDecoder = new SaltrDecoder();
        _isLoading = false;
        _ready = false;
    }

    //TODO: decoder shouldn't be visible here at all!
    public function get saltDecoder():SaltrDecoder {
        return _saltDecoder;
    }

    public function get saltUserId():String {
        return _saltUserId;
    }

    public function get userId():String {
        throw new PureVirtualFunctionError();
    }

    public function get ready():Boolean {
        return _ready;
    }

    public function getFeatureByToken(token:String):Feature {
        for each(var feature:Feature in _saltDecoder.features) {
            if (feature.token == token) {
                return feature;
            }
        }
        return null;
    }

    public function addProperty(propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void {
        _api.addProperty(_saltUserId, _instanceKey, propertyNames, propertyValues, operations);
    }


    public function initPartner(partner:String, user:User):void {
        var saltPartnerDTO:SaltrPartnerDTO = new SaltrPartnerDTO();
        saltPartnerDTO.partnerType = partner;
        saltPartnerDTO.firstName = user.firstname;
        saltPartnerDTO.lastName = user.lastname;
        saltPartnerDTO.gender = user.gender;
        saltPartnerDTO.partnerId = user.id;
        _partnerDTO = saltPartnerDTO;
    }

    public function getAppData(platform:String):void {
        throw  new PureVirtualFunctionError();
    }

    protected function loadAppDataSuccessHandler(jsonData:Object):void {
        _isLoading = false;
        _ready = true;
        _saltUserId = jsonData.saltId;
        _saltDecoder.decode(jsonData);
        trace("[SaltClient] packs=" + _saltDecoder.levelPackStructures.length);
        dispatchEventWith(EVENT_APPDATA_READY_FOR_SETTING);
        dispatchEventWith(EVENT_APPDATA_READY_FOR_USE);
    }

    private function loadAppDataFailHandler():void {
        _isLoading = false;
        _ready = false;
        trace("[SaltClient] ERROR: Level Packs are not loaded.");
    }

    protected function loadAppDataInternal():void {
        trace("[SaltClient] NO Internet available - so loading internal app data.");
        var data:Object = _storage.getObject(PACKS_DATA_URL_CACHE, Storage.FROM_CACHE);
        if (data != null) {
            trace("[SaltClient] Loading App data from Cache folder.");

            loadAppDataSuccessHandler(data);
        }
        else {
            trace("[SaltClient] Loading App data from application folder.");
            data = _storage.getObject(PACKS_DATA_URL_INTERNAL, Storage.FROM_APP);
            if (data != null) {
                loadAppDataSuccessHandler(data);
            }
            else {
                loadAppDataFailHandler();
            }

        }
    }

    /////////////////////////////////////

    public function getLevelDataBody(levelPackData:LevelPackStructure, levelData:LevelStructure):void {
        CONFIG::dev{
            loadLevelDataFromServer(levelPackData, levelData, true);
        }
        CONFIG::stage{
            loadLevelDataFromServer(levelPackData, levelData, true);
        }

        CONFIG::live{
            //if there are no version change than load from cache
            var cachedFileName:String = formatString(LEVEL_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
            if (levelData.version == _storage.getObjectVersion(cachedFileName, Storage.FROM_CACHE)) {
                loadLevelDataCached(levelData, cachedFileName);
            } else {
                loadLevelDataFromServer(levelPackData, levelData);
            }
        }


    }

    protected function levelLoadSuccessHandler(levelData:LevelStructure, data:Object):void {
        levelData.parseData(data);
        dispatchEventWith(EVENT_LEVELDATA_READY);
    }

    protected function levelLoadErrorHandler():void {
        trace("[SaltClient] ERROR: Level data is not loaded.");
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
        var asset:JSONAsset = new JSONAsset("level", ticket);
        asset.addEventListener(Asset.EVENT_LOAD_COMPLETE, levelDataLoadedHandler);
        asset.addEventListener(Asset.EVENT_LOAD_ERROR, levelDataLoadErrorHandler);
        asset.load();
        //
        //TODO @GSAR: get rid of nested functions!
        function levelDataLoadedHandler(event:Event):void {
            asset.removeEventListener(Asset.EVENT_LOAD_COMPLETE, levelDataLoadedHandler);
            asset.removeEventListener(Asset.EVENT_LOAD_ERROR, levelDataLoadErrorHandler);
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

        function levelDataLoadErrorHandler(event:Event):void {
            asset.removeEventListener(Asset.EVENT_LOAD_COMPLETE, levelDataLoadedHandler);
            asset.removeEventListener(Asset.EVENT_LOAD_ERROR, levelDataLoadErrorHandler);
            var cachedFileName:String = formatString(LEVEL_DATA_URL_CACHE_TEMPLATE, levelPackData.index, levelData.index);
            loadLevelDataLocally(levelPackData, levelData, cachedFileName);
            asset.dispose();
        }
    }
}
}
