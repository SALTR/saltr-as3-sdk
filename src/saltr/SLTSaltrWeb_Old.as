/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;

import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;
import saltr.resource.SLTResource;
import saltr.resource.SLTResourceURLTicket;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusExperimentsParseError;
import saltr.status.SLTStatusFeaturesParseError;
import saltr.status.SLTStatusLevelContentLoadFail;
import saltr.status.SLTStatusLevelsParseError;
import saltr.utils.SLTUtils;
import saltr.saltr_internal;

use namespace saltr_internal;

//TODO:: @daal add some flushCache method.
/**
 * @private
 */
public class SLTSaltrWeb_Old {

    public static const CLIENT:String = "AS3-Web";
    public static const API_VERSION:String = "1.0.1";

    private var _socialId:String;
    private var _connected:Boolean;
    private var _clientKey:String;
    private var _isLoading:Boolean;

    private var _activeFeatures:Dictionary;
    private var _developerFeatures:Dictionary;

    private var _experiments:Vector.<SLTExperiment>;
    private var _levelPacks:Vector.<SLTLevelPack>;

    private var _connectSuccessCallback:Function;
    private var _connectFailCallback:Function;
    private var _levelContentLoadSuccessCallback:Function;
    private var _levelContentLoadFailCallback:Function;

    private var _requestIdleTimeout:int;
    private var _devMode:Boolean;
    private var _started:Boolean;
    private var _useNoLevels:Boolean;
    private var _useNoFeatures:Boolean;
    private var _levelType:String;

    private static function getTicket(url:String, vars:URLVariables, timeout:int = 0):SLTResourceURLTicket {
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(url, vars);
        ticket.method = URLRequestMethod.POST;
        if (timeout > 0) {
            ticket.idleTimeout = timeout;
        }
        return ticket;
    }

    public function SLTSaltrWeb_Old(clientKey:String) {
        _clientKey = clientKey;
        _isLoading = false;
        _connected = false;
        _useNoLevels = false;
        _useNoFeatures = false;
        _levelType = null;

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

    public function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    public function set socialId(socialId:String):void {
        _socialId = socialId;
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

    public function importLevelContentFromJSON(json:String, sltLevel:SLTLevel):void {
        if (_useNoLevels) {
            return;
        }

        var content:Object = JSON.parse(json);
        sltLevel.updateContent(content);
    }

    public function importLevelsFromJSON(json:String):void {
        if (_useNoLevels) {
            return;
        }

        var applicationData:Object = JSON.parse(json);
        _levelPacks = SLTDeserializer.decodeLevels(applicationData);
    }

    public function importDeveloperFeaturesFromJSON(json:String):void {
        if (_useNoFeatures) {
            return;
        }

        var featuresJSON:Object = JSON.parse(json);
        _developerFeatures = SLTDeserializer.decodeFeatures(featuresJSON);
    }

    /**
     * If you want to have a feature synced with SALTR you should call define before getAppData call.
     */
    public function defineFeature(token:String, properties:Object, required:Boolean = false):void {
        if (_useNoFeatures) {
            return;
        }

        if (_started == false) {
            _developerFeatures[token] = new SLTFeature(token, properties, required);
        } else {
            throw new Error("Method 'defineFeature()' should be called before 'start()' only.");
        }
    }

    public function start():void {
        if (_socialId == null) {
            throw new Error("'socialId' field is required and can't be null.");
        }

        if (SLTUtils.getDictionarySize(_developerFeatures) == 0 && _useNoFeatures == false) {
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
        _connectSuccessCallback = successCallback;
        _connectFailCallback = failCallback;

        _isLoading = true;
        var resource:SLTResource = createAppDataResource(appDataLoadSuccessCallback, appDataLoadFailCallback, basicProperties, customProperties);
        resource.load();
    }

    public function loadLevelContent(sltLevel:SLTLevel, successCallback:Function, failCallback:Function):void {
        _levelContentLoadSuccessCallback = successCallback;
        _levelContentLoadFailCallback = failCallback;
        loadLevelContentFromSaltr(sltLevel);
    }

    public function addProperties(basicProperties:Object = null, customProperties:Object = null):void {
        if (!basicProperties && !customProperties) {
            return;
        }

        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.cmd = SLTConfig.ACTION_ADD_PROPERTIES; //TODO @GSAR: remove later
        urlVars.action = SLTConfig.ACTION_ADD_PROPERTIES;

        args.apiVersion = API_VERSION;
        args.clientKey = _clientKey;
        args.client = CLIENT;

        //required for Web
        if (_socialId != null) {
            args.socialId = _socialId;
        } else {
            throw new Error("Field 'socialId' is required.")
        }

        //optional
        if (basicProperties != null) {
            args.basicProperties = basicProperties;
        }

        //optional
        if (customProperties != null) {
            args.customProperties = customProperties;
        }

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);

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

    protected function syncSuccessHandler(resource:SLTResource):void {
        trace("[Saltr] Dev feature Sync is complete.");
    }

    protected function syncFailHandler(resource:SLTResource):void {
        trace("[Saltr] Dev feature Sync has failed.");
    }

    protected function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var url:String = sltLevel.contentUrl + "?_time_=" + new Date().getTime();
        var ticket:SLTResourceURLTicket = getTicket(url, null, _requestIdleTimeout);
        var resource:SLTResource = new SLTResource("saltr", ticket, loadFromSaltrSuccessCallback, loadFromSaltrFailCallback);
        resource.load();

        function loadFromSaltrSuccessCallback():void {
            var content:Object = resource.jsonData;
            if (content != null) {
                levelContentLoadSuccessHandler(sltLevel, content);
            }
            else {
                levelContentLoadFailHandler();
            }
            resource.dispose();
        }

        function loadFromSaltrFailCallback():void {
            levelContentLoadFailHandler();
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

    private function createAppDataResource(loadSuccessCallback:Function, loadFailCallback:Function, basicProperties:Object = null, customProperties:Object = null):SLTResource {
        var urlVars:URLVariables = new URLVariables();
        urlVars.cmd = SLTConfig.ACTION_GET_APP_DATA; //TODO @GSAR: remove later
        urlVars.action = SLTConfig.ACTION_GET_APP_DATA;

        var args:Object = {};

        args.apiVersion = API_VERSION;
        args.clientKey = _clientKey;
        args.client = CLIENT;

        //required for Web
        if (_socialId != null) {
            args.socialId = _socialId;
        } else {
            throw new Error("Field 'socialId' is required.")
        }

        if (basicProperties != null) {
            args.basicProperties = basicProperties;
        }

        if (customProperties != null) {
            args.customProperties = customProperties;
        }

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);

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

        var success:Boolean = false;
        var response:Object;

        if (data.hasOwnProperty("response")) {
            response = data.response[0];
            success = response.success;
        } else {
            //TODO @GSAR: remove later when  API is versioned!
            response = data.responseData;
            success = data.status == SLTConfig.RESULT_SUCCEED;
        }

        _isLoading = false;

        if (success) {

            if (_devMode) {
                syncDeveloperFeatures();
            }

            _levelType = response.levelType;
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

            // if developer didn't announce use without levels, and levelType in returned JSON is not "noLevels",
            // then - parse levels
            if (!_useNoLevels && _levelType != SLTLevel.LEVEL_TYPE_NONE) {
                var newLevelPacks:Vector.<SLTLevelPack>;
                try {
                    newLevelPacks = SLTDeserializer.decodeLevels(response);
                } catch (e:Error) {
                    _connectFailCallback(new SLTStatusLevelsParseError());
                    return;
                }

                // if new levels are received and parsed, then only dispose old ones and assign new ones.
                if (newLevelPacks != null) {
                    disposeLevelPacks();
                    _levelPacks = newLevelPacks;
                }
            }

            _connected = true;

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

    private function disposeLevelPacks():void {
        for (var i:int = 0, len:int = _levelPacks.length; i < len; ++i) {
            _levelPacks[i].dispose();
        }
        _levelPacks.length = 0;
    }

    private function syncDeveloperFeatures():void {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.cmd = SLTConfig.ACTION_DEV_SYNC_DATA; //TODO @GSAR: remove later
        urlVars.action = SLTConfig.ACTION_DEV_SYNC_DATA;

        args.apiVersion = API_VERSION;
        args.clientKey = _clientKey;
        args.client = CLIENT;

        //required for Web
        if (_socialId != null) {
            args.socialId = _socialId;
        } else {
            throw new Error("Field 'socialId' is required.")
        }

        var featureList:Array = [];
        for (var i:String in _developerFeatures) {
            var feature:SLTFeature = _developerFeatures[i];
            featureList.push({token: feature.token, value: JSON.stringify(feature.properties)});
        }
        args.developerFeatures = featureList;
        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);

        var ticket:SLTResourceURLTicket = getTicket(SLTConfig.SALTR_DEVAPI_URL, urlVars);
        var resource:SLTResource = new SLTResource("syncFeatures", ticket, syncSuccessHandler, syncFailHandler);
        resource.load();
    }

    private static function removeEmptyAndNullsJSONReplacer(k:*, v:*):* {
        if (v != null && v != "null" && v != "") {
            return v;
        }
        return undefined;
    }
}
}
