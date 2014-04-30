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

import saltr.resource.SLTResource;
import saltr.resource.SLTResourceURLTicket;

//TODO:: @daal add some flushCache method.
public class SLTSaltrWeb {

    protected var _saltrUserId:String;
    protected var _isLoading:Boolean;
    protected var _connected:Boolean;
    protected var _partner:SLTPartner;

    protected var _clientKey:String;
    protected var _features:Dictionary;
    protected var _levelPacks:Vector.<SLTLevelPack>;
    protected var _experiments:Vector.<SLTExperiment>;
    protected var _deviceId:String;
    protected var _onAppDataLoadSuccess:Function;
    protected var _onAppDataLoadFail:Function;
    protected var _onContentDataLoadSuccess:Function;
    protected var _onContentDataFail:Function;

    private var _isInDevMode:Boolean;
    private var _appVersion:String;


    //TODO @GSAR: clean up all classes method order - to give SDK a representative look!
    public function SLTSaltrWeb(clientKey:String) {
        _clientKey = clientKey;
        _isLoading = false;
        _connected = false;

        //TODO @GSAR: implement usage of dev mode variable
        _isInDevMode = true;
        _features = new Dictionary();
    }

    public function set appVersion(value:String):void {
        _appVersion = value;
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

    public function importLevelFromJSON(json:String, level:SLTLevel):void {
        var data:Object = JSON.parse(json);
        level.updateContent(data);
    }

    public function importLevelPacksFromJSON(json:String):void {
        var applicationData:Object = JSON.parse(json);
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

    public function start(onDataLoadSuccess:Function, onDataLoadFail:Function):void {
        if (_isLoading) {
            return;
        }
        _onAppDataLoadSuccess = onDataLoadSuccess;
        _onAppDataLoadFail = onDataLoadFail;

        _isLoading = true;
        _connected = false;
        var resource:SLTResource = createAppDataResource(appDataLoadCompleteCallback, appDataLoadFailedCallback);
        resource.load();
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
        args.clientKey = _clientKey;
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
        _onAppDataLoadFail(new SLTError(SLTError.GENERAL_ERROR_CODE, "could not connect to SALTR"));
    }

    private function appDataLoadCompleteCallback(resource:SLTResource):void {
        var data:Object = resource.jsonData;
        var status : String = data.status;
        var responseData:Object = data.responseData;
        _isLoading = false;
        if(status == SLTConfig.RESULT_SUCCEED) {
            _connected = true;

            //TODO @daal. supporting saltId(old) and saltrUserId.
            var saltrUserId = responseData.hasOwnProperty("saltrUserId") ? responseData.saltrUserId : responseData.saltId;
            _saltrUserId = saltrUserId;

            _experiments = SLTDeserializer.decodeExperiments(responseData);
            _levelPacks = SLTDeserializer.decodeLevels(responseData);
            var saltrFeatures:Dictionary = SLTDeserializer.decodeFeatures(responseData);

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
        else {
            _connected = false;
            _onAppDataLoadFail(new SLTError(responseData.errorCode, responseData.errorMessage));
        }
        resource.dispose();
    }

    private function createAppDataResource(appDataAssetLoadCompleteHandler:Function, appDataAssetLoadErrorHandler:Function):SLTResource {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = SLTConfig.COMMAND_APP_DATA;
        var args:Object = {};
        if (_deviceId != null) {
            args.deviceId = _deviceId;
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


    /////////////////////////////////////// level content data loading methods.

    public function loadLevelContentData(levelPack:SLTLevelPack, level:SLTLevel, successCallback:Function, failCallback:Function):void {
        _onContentDataLoadSuccess = successCallback;
        _onContentDataFail = failCallback;
        loadLevelContentDataFromSaltr(levelPack, level, true);
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
            if (contentData == null) {
                levelLoadErrorHandler();
            }
            else {
                levelLoadSuccessHandler(level, contentData);
            }
            resource.dispose();
        }

        function contentDataLoadFailedCallback():void {
            levelLoadErrorHandler();
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
