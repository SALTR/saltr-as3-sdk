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
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusExperimentsParseError;
import saltr.status.SLTStatusFeaturesParseError;
import saltr.status.SLTStatusLevelContentLoadFail;
import saltr.status.SLTStatusLevelsParseError;
import saltr.utils.Utils;

//TODO:: @daal add some flushCache method.
public class SLTSaltrMobile {

    protected var _socialId:String;
    protected var _socialNetwork:String;
    protected var _deviceId:String;
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


    //TODO @GSAR: make common class for mobile and web
    //TODO @GSAR: add Properties class to handle correct feature properties assignment
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
        _levelPacks = new <SLTLevelPack>[];

        _repository = useCache ? new SLTMobileRepository() : new SLTDummyRepository();
    }

    public function set appVersion(value:String):void {
        _appVersion = value;
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

    public function set deviceId(value:String):void {
        _deviceId = value;
    }

    public function get levelPacks():Vector.<SLTLevelPack> {
        return _levelPacks;
    }

    public function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    public function setSocial(socialId:String, socialNetwork:String):void {
        if (socialId == null || socialNetwork == null) {
            throw new Error("Both variables - 'socialId' and 'socialNetwork' are required and should be non 'null'.");
        }

        _socialId = socialId;
        _socialNetwork = socialNetwork;
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
        if (_started == false) {
            _developerFeatures[token] = new SLTFeature(token, properties, required);
        } else {
            throw new Error("Method 'defineFeature()' should be called before 'start()' only.");
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

    public function loadLevelContent(levelPack:SLTLevelPack, level:SLTLevel, loadSuccessCallback:Function, loadFailCallback:Function, useCache:Boolean = true):void {
        _levelContentLoadSuccessCallback = loadSuccessCallback;
        _levelContentLoadFailCallback = loadFailCallback;
        var content:Object;
        if (_connected == false) {
            if (useCache) {
                content = loadLevelContentInternally(levelPack, level);
            } else {
                content = loadLevelContentFromDisk(levelPack, level);
            }
            levelContentLoadSuccessHandler(level, content);
        } else {
            if (useCache == false || level.version != getCachedLevelVersion(levelPack, level)) {
                loadLevelContentFromSALTR(levelPack, level);
            } else {
                content = loadLevelContentFromCache(levelPack, level);
                levelContentLoadSuccessHandler(level, content);
            }
        }
    }

    private function createAppDataResource(appDataAssetLoadCompleteHandler:Function, appDataAssetLoadErrorHandler:Function):SLTResource {
        var urlVars:URLVariables = new URLVariables();
        urlVars.cmd = SLTConfig.CMD_APP_DATA;
        var args:Object = {};
        if (_deviceId != null) {
            args.deviceId = _deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

        if (_socialId != null && _socialNetwork != null) {
            args.socialId = _socialId;
            args.socialNetwork = _socialNetwork;
        }
        args.clientKey = _clientKey;
        urlVars.args = JSON.stringify(args);
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_API_URL, urlVars);
        return new SLTResource("saltAppConfig", ticket, appDataAssetLoadCompleteHandler, appDataAssetLoadErrorHandler);
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
                _appDataLoadFailCallback(new SLTStatusFeaturesParseError());
                return;
            }

            try {
                _experiments = SLTDeserializer.decodeExperiments(responseData);
            } catch (e:Error) {
                _appDataLoadFailCallback(new SLTStatusExperimentsParseError());
                return;
            }

            try {
                _levelPacks = SLTDeserializer.decodeLevels(responseData);
            } catch (e:Error) {
                _appDataLoadFailCallback(new SLTStatusLevelsParseError());
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
            _appDataLoadFailCallback(new SLTStatus(responseData.errorCode, responseData.errorMessage));
        }
        resource.dispose();
    }

    private function appDataLoadFailHandler(resource:SLTResource):void {
        resource.dispose();
        _isLoading = false;
        _appDataLoadFailCallback(new SLTStatusAppDataLoadFail());
    }

    private function syncDeveloperFeatures():void {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.cmd = SLTConfig.CMD_DEV_SYNC_FEATURES;
        args.clientKey = _clientKey;
        if (_appVersion) {
            args.appVersion = _appVersion;
        }

        var featureList:Array = [];
        for (var i:String in _developerFeatures) {
            var feature:SLTFeature = _developerFeatures[i];
            featureList.push({token: feature.token, value: JSON.stringify(feature.properties)});
        }
        args.developerFeatures = JSON.stringify(featureList);
        urlVars.args = JSON.stringify(args);

        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_DEVAPI_URL, urlVars);
        var resource:SLTResource = new SLTResource("syncFeatures", ticket, syncSuccessHandler, syncFailHandler);
        resource.load();
    }

    protected function syncSuccessHandler(resource:SLTResource):void {
        trace("[Saltr] Dev feature Sync is complete.");
    }

    protected function syncFailHandler(resource:SLTResource):void {
        trace("[Saltr] Dev feature Sync has failed.");
    }

    private function getCachedLevelVersion(levelPack:SLTLevelPack, level:SLTLevel):String {
        var cachedFileName:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectVersion(cachedFileName);
    }

    private function cacheLevelContent(levelPack:SLTLevelPack, level:SLTLevel, content:Object):void {
        var cachedFileName:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, levelPack.index, level.index);
        _repository.cacheObject(cachedFileName, String(level.version), content);
    }

    private function loadLevelContentInternally(levelPack:SLTLevelPack, level:SLTLevel):Object {
        var contentData:Object = loadLevelContentFromCache(levelPack, level);
        if (contentData == null) {
            contentData = loadLevelContentFromDisk(levelPack, level);
        }
        return contentData;
    }

    private function loadLevelContentFromCache(levelPack:SLTLevelPack, level:SLTLevel):Object {
        var url:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectFromCache(url);
    }

    private function loadLevelContentFromDisk(levelPack:SLTLevelPack, level:SLTLevel):Object {
        var url:String = Utils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_PACKAGE_URL_TEMPLATE, levelPack.index, level.index);
        return _repository.getObjectFromApplication(url);
    }

    protected function loadLevelContentFromSALTR(levelPack:SLTLevelPack, level:SLTLevel):void {
        var dataUrl:String = level.contentUrl + "?_time_=" + new Date().getTime();
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(dataUrl);
        var resource:SLTResource = new SLTResource("saltr", ticket, loadSuccessInternalHandler, loadFailInternalHandler);
        resource.load();

        function loadSuccessInternalHandler():void {
            var contentData:Object = resource.jsonData;
            if (contentData != null) {
                cacheLevelContent(levelPack, level, contentData);
            }
            else {
                contentData = loadLevelContentInternally(levelPack, level);
            }

            if (contentData != null) {
                levelContentLoadSuccessHandler(level, contentData);
            }
            else {
                levelContentLoadFailHandler();
            }
            resource.dispose();
        }

        function loadFailInternalHandler():void {
            var contentData:Object = loadLevelContentInternally(levelPack, level);
            levelContentLoadSuccessHandler(level, contentData);
            resource.dispose();
        }
    }

    protected function levelContentLoadSuccessHandler(level:SLTLevel, data:Object):void {
        level.updateContent(data);
        _levelContentLoadSuccessCallback();
    }

    protected function levelContentLoadFailHandler():void {
        _levelContentLoadFailCallback(new SLTStatusLevelContentLoadFail());
    }

    //TODO @GSAR: port this later when SALTR is ready
    private function addUserProperty(propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void {
//        var urlVars:URLVariables = new URLVariables();
//        urlVars.cmd = SLTConfig.COMMAND_ADD_PROPERTY;
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
//        urlVars.args = JSON.stringify(args);
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
}
}
