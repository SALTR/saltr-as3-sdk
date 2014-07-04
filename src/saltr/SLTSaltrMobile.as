/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.net.URLRequestMethod;
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

    protected var _connectSuccessCallback:Function;
    protected var _connectFailCallback:Function;
    protected var _levelContentLoadSuccessCallback:Function;
    protected var _levelContentLoadFailCallback:Function;

    private var _requestIdleTimeout:int;
    private var _devMode:Boolean;
    private var _started:Boolean;
    private var _useNoLevels:Boolean;
    private var _useNoFeatures:Boolean;


    //TODO @GSAR: make common class for mobile and web
    //TODO @GSAR: add Properties class to handle correct feature properties assignment
    //TODO @GSAR: clean up all classes method order - to give SDK a representative look!
    public function SLTSaltrMobile(clientKey:String, deviceId:String, useCache:Boolean = true) {
        _clientKey = clientKey;
        _deviceId = deviceId;
        _isLoading = false;
        _connected = false;
        _saltrUserId = null;
        _useNoLevels = false;
        _useNoFeatures = false;

        _devMode = false;
        _started = false;
        _requestIdleTimeout = 0;

        _activeFeatures = new Dictionary();
        _developerFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
        _levelPacks = new <SLTLevelPack>[];

        _repository = useCache ? new SLTMobileRepository() : new SLTDummyRepository();
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

    //TODO @GSAR: will be removed probably later
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

    public function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    public function set socialId(socialId:String):void {
        _socialId = socialId;
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
            _saltrUserId = cachedData.saltrUserId;
        }

        _started = true;
    }

    public function connect(successCallback:Function, failCallback:Function, basicProperties:Object = null, customProperties:Object = null):void {
        if (_isLoading || !_started) {
            return;
        }
        _connectSuccessCallback = successCallback;
        _connectFailCallback = failCallback;

        _isLoading = true;
        var resource:SLTResource = createAppDataResource(appDataLoadSuccessCallback, appDataLoadFailCallback, basicProperties, customProperties);
        resource.load();
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
        if (!basicProperties && !customProperties || !_saltrUserId) {
            return;
        }

        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.cmd = SLTConfig.CMD_ADD_PROPERTIES;

        args.clientKey = _clientKey;

        if (_deviceId != null) {
            args.deviceId = _deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

        if (_socialId != null) {
            args.socialId = _socialId;
        }

        if (_saltrUserId != null) {
            args.saltrUserId = _saltrUserId;
        }

        if (basicProperties != null) {
            args.basicProperties = basicProperties;
        }

        if (customProperties != null) {
            args.customProperties = customProperties;
        }

        urlVars.args = JSON.stringify(args);

        var ticket:SLTResourceURLTicket = getTicket(SLTConfig.SALTR_API_URL, urlVars, _requestIdleTimeout);
        var resource:SLTResource = new SLTResource("property", ticket,
                function (resource:SLTResource):void {
                    trace("success");
                    var data:Object = resource.jsonData;
                    resource.dispose();
                },
                function (resource:SLTResource):void {
                    trace("error");
                    resource.dispose();
                });
        resource.load();
    }

    private function createAppDataResource(loadSuccessCallback:Function, loadFailCallback:Function, basicProperties:Object = null, customProperties:Object = null):SLTResource {
        var urlVars:URLVariables = new URLVariables();
        urlVars.cmd = SLTConfig.CMD_APP_DATA;
        var args:Object = {};

        args.clientKey = _clientKey;

        if (_deviceId != null) {
            args.deviceId = _deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

        if (_socialId != null) {
            args.socialId = _socialId;
        }

        if (_saltrUserId != null) {
            args.saltrUserId = _saltrUserId;
        }

        if (basicProperties != null) {
            args.basicProperties = basicProperties;
        }

        if (customProperties != null) {
            args.customProperties = customProperties;
        }

        urlVars.args = JSON.stringify(args);
        var ticket:SLTResourceURLTicket = getTicket(SLTConfig.SALTR_API_URL, urlVars, _requestIdleTimeout);
        return new SLTResource("saltAppConfig", ticket, loadSuccessCallback, loadFailCallback);
    }

    private function appDataLoadSuccessCallback(resource:SLTResource):void {
        var data:Object = resource.jsonData;

        if (data == null) {
            _connectFailCallback(new SLTStatusAppDataLoadFail());
            resource.dispose();
            return;
        }

        var status:String = data.status;
        var response:Object = data.responseData;
        _isLoading = false;
        if (_devMode) {
            syncDeveloperFeatures();
        }

        if (status == SLTConfig.RESULT_SUCCEED) {
            var saltrFeatures:Dictionary;
            try {
                saltrFeatures = SLTDeserializer.decodeFeatures(response);
            } catch (e:Error) {
                _connectFailCallback(new SLTStatusFeaturesParseError());
                return;
            }

            try {
                _experiments = SLTDeserializer.decodeExperiments(response);
            } catch (e:Error) {
                _connectFailCallback(new SLTStatusExperimentsParseError());
                return;
            }

            try {
                _levelPacks = SLTDeserializer.decodeLevels(response);
            } catch (e:Error) {
                _connectFailCallback(new SLTStatusLevelsParseError());
                return;
            }

            _saltrUserId = response.saltrUserId;
            _connected = true;
            _repository.cacheObject(SLTConfig.APP_DATA_URL_CACHE, "0", response);

            _activeFeatures = saltrFeatures;
            _connectSuccessCallback();

            trace("[SALTR] AppData load success. LevelPacks loaded: " + _levelPacks.length);

            //TODO @GSAR: later we need to report the feature set differences by an event or a callback to client;
        }
        else {
            _connectFailCallback(new SLTStatus(response.errorCode, response.errorMessage));
        }

        resource.dispose();
    }

    private function appDataLoadFailCallback(resource:SLTResource):void {
        resource.dispose();
        _isLoading = false;
        _connectFailCallback(new SLTStatusAppDataLoadFail());
    }

    private function syncDeveloperFeatures():void {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.cmd = SLTConfig.CMD_DEV_SYNC_FEATURES;
        args.clientKey = _clientKey;

        if (_deviceId != null) {
            args.deviceId = _deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

        if (_socialId != null) {
            args.socialId = _socialId;
        }

        if (_saltrUserId != null) {
            args.saltrUserId = _saltrUserId;
        }

        var featureList:Array = [];
        for (var i:String in _developerFeatures) {
            var feature:SLTFeature = _developerFeatures[i];
            featureList.push({token: feature.token, value: JSON.stringify(feature.properties)});
        }
        args.developerFeatures = featureList;
        urlVars.args = JSON.stringify(args);

        var ticket:SLTResourceURLTicket = getTicket(SLTConfig.SALTR_DEVAPI_URL, urlVars);
        var resource:SLTResource = new SLTResource("syncFeatures", ticket, syncSuccessHandler, syncFailHandler);
        resource.load();
    }

    protected function syncSuccessHandler(resource:SLTResource):void {
        trace("[Saltr] Dev feature Sync is complete.");
    }

    protected function syncFailHandler(resource:SLTResource):void {
        trace("[Saltr] Dev feature Sync has failed.");
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

    protected function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var url:String = sltLevel.contentUrl + "?_time_=" + new Date().getTime();
        var ticket:SLTResourceURLTicket = getTicket(url, null, _requestIdleTimeout);
        var resource:SLTResource = new SLTResource("saltr", ticket, loadFromSaltrSuccessCallback, loadFromSaltrFailCallback);
        resource.load();

        function loadFromSaltrSuccessCallback():void {
            var content:Object = resource.jsonData;
            if (content != null) {
                cacheLevelContent(sltLevel, content);
            }
            else {
                content = loadLevelContentInternally(sltLevel);
            }

            if (content != null) {
                levelContentLoadSuccessHandler(sltLevel, content);
            }
            else {
                levelContentLoadFailHandler();
            }
            resource.dispose();
        }

        function loadFromSaltrFailCallback():void {
            var content:Object = loadLevelContentInternally(sltLevel);
            levelContentLoadSuccessHandler(sltLevel, content);
            resource.dispose();
        }
    }

    protected function levelContentLoadSuccessHandler(sltLevel:SLTLevel, content:Object):void {
        sltLevel.updateContent(content);
        _levelContentLoadSuccessCallback();
    }

    protected function levelContentLoadFailHandler():void {
        _levelContentLoadFailCallback(new SLTStatusLevelContentLoadFail());
    }

    private function getTicket(url:String, vars:URLVariables, timeout:int = 0):SLTResourceURLTicket {
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(url, vars);
        ticket.method = URLRequestMethod.POST;
        if (timeout > 0) {
            ticket.idleTimeout = timeout;
        }
        return ticket;
    }
}
}
