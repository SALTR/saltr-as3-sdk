/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;

import saltr.parser.game.SLTLevel;
import saltr.parser.game.SLTLevelPack;
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
public class SLTSaltrWeb implements IWebSaltr {

    protected var _socialId:String;
    protected var _socialNetwork:String;
    protected var _connected:Boolean;
    protected var _clientKey:String;
    protected var _saltrUserId:String;
    protected var _isLoading:Boolean;

    protected var _activeFeatures:Dictionary;
    protected var _developerFeatures:Dictionary;

    protected var _experiments:Vector.<SLTExperiment>;
    protected var _levelPacks:Vector.<SLTLevelPack>;

    protected var _appDataLoadSuccessCallback:Function;
    protected var _appDataLoadFailCallback:Function;
    protected var _levelContentLoadSuccessCallback:Function;
    protected var _levelContentLoadFailCallback:Function;

    private var _requestIdleTimeout:int;
    private var _devMode:Boolean;
    private var _started:Boolean;
    private var _useNoLevels:Boolean;
    private var _useNoFeatures:Boolean;

    //TODO @GSAR: clean up all classes method order - to give SDK a representative look!
    public function SLTSaltrWeb(clientKey:String) {
        _clientKey = clientKey;
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

    public function setSocial(socialId:String, socialNetwork:String):void {
        if (socialId == null || socialNetwork == null) {
            throw new Error("Both variables - 'socialId' and 'socialNetwork' are required and should be non 'null'.");
        }

        _socialId = socialId;
        _socialNetwork = socialNetwork;
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

    public function importLevelContentFromJSON(json:String, level:SLTLevel):void {
        var data:Object = JSON.parse(json);
        level.updateContent(data);
    }

    public function importLevelsFromJSON(json:String):void {
        var applicationData:Object = JSON.parse(json);
        _levelPacks = SLTDeserializer.decodeLevels(applicationData);
    }

    public function importDeveloperFeaturesFromJSON(json:String):void {
        var featuresJSON:Object = JSON.parse(json);
        _developerFeatures = SLTDeserializer.decodeFeatures(featuresJSON);
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
        if (_socialId == null || _socialNetwork == null) {
            throw new Error("'socialId' and 'socialNetwork' fields are required and can't be null.");
        }

        if (Utils.getDictionarySize(_developerFeatures) == 0 && _useNoFeatures == false) {
            throw new Error("Features should be defined.");
        }

        if (_levelPacks.length == 0 && _useNoLevels == false) {
            throw new Error("Levels should be imported.");
        }

        for (var i:String in _developerFeatures) {
            _activeFeatures[i] = _developerFeatures[i];
        }

        _started = true;
    }

    public function connect(successCallback:Function, failCallback:Function, basicProperties:Object = null, customProperties:Object = null):void {
        if (_isLoading || !_started) {
            return;
        }
        _appDataLoadSuccessCallback = successCallback;
        _appDataLoadFailCallback = failCallback;

        _isLoading = true;
        var resource:SLTResource = createAppDataResource(appDataLoadSuccessHandler, appDataLoadFailHandler, basicProperties, customProperties);
        resource.load();
    }

    public function loadLevelContent(index:int, successCallback:Function, failCallback:Function):void {
        var sltLevel:SLTLevel = getLevelByGlobalIndex(index);
        _levelContentLoadSuccessCallback = successCallback;
        _levelContentLoadFailCallback = failCallback;
        loadLevelContentFromSaltr(sltLevel);
    }

    public function addProperties(basicProperties:Object = null, customProperties:Object = null):void {
        if (!basicProperties && !customProperties || !_saltrUserId) {
            return;
        }

        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.cmd = SLTConfig.CMD_ADD_PROPERTIES;

        args.clientKey = _clientKey;
        args.saltrUserId = _saltrUserId;

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

    private function createAppDataResource(appDataAssetLoadCompleteHandler:Function, appDataAssetLoadErrorHandler:Function, basicProperties:Object = null, customProperties:Object = null):SLTResource {
        var urlVars:URLVariables = new URLVariables();
        urlVars.cmd = SLTConfig.CMD_APP_DATA;
        var args:Object = {};

        if (!_saltrUserId) {
            if (_socialId != null && _socialNetwork != null) {
                args.socialId = _socialId;
                args.socialNetwork = _socialNetwork;
            } else {
                throw new Error("In SALTR for Web 'socialId' and 'socialNetwork' are required fields.");
            }
        } else {
            args.saltrUserId = _saltrUserId;
        }

        args.clientKey = _clientKey;

        if (basicProperties != null) {
            args.basicProperties = basicProperties;
        }

        if (customProperties != null) {
            args.customProperties = customProperties;
        }

        urlVars.args = JSON.stringify(args);
        var ticket:SLTResourceURLTicket = getTicket(SLTConfig.SALTR_API_URL, urlVars, _requestIdleTimeout);
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

    //TODO:: @daal do we need this forceNoCache?
    protected function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var url:String = sltLevel.contentUrl + "?_time_=" + new Date().getTime();
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(url);
        if (_requestIdleTimeout > 0) {
            ticket.idleTimeout = _requestIdleTimeout;
        }
        var resource:SLTResource = new SLTResource("saltr", ticket, loadSuccessInternalCallback, loadFailInternalCallback);
        resource.load();

        function loadSuccessInternalCallback():void {
            var content:Object = resource.jsonData;
            if (content != null) {
                levelContentLoadSuccessHandler(sltLevel, content);
            }
            else {
                levelContentLoadFailHandler();
            }
            resource.dispose();
        }

        function loadFailInternalCallback():void {
            levelContentLoadFailHandler();
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

    private function getTicket(url:String, vars:URLVariables, timeout:int = 0):SLTResourceURLTicket {
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(SLTConfig.SALTR_API_URL, vars);
        ticket.method = URLRequestMethod.POST;
        if (timeout > 0) {
            ticket.idleTimeout = timeout;
        }
        return ticket;
    }
}
}
