/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.utils.Dictionary;

use namespace saltr_internal;

public class AppData {

    private var _activeFeatures:Dictionary;
    private var _developerFeatures:Dictionary;
    private var _experiments:Vector.<SLTExperiment>;


    public function AppData() {
        _activeFeatures = new Dictionary();
        _developerFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
    }

    public function get activeFeatures():Dictionary {
        return _activeFeatures;
    }

    public function get developerFeatures():Dictionary {
        return _developerFeatures;
    }

    public function get experiments():Vector.<SLTExperiment> {
        return _experiments;
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

    public function defineFeature(token:String, properties:Object, required:Boolean):void {
        if (validateToken(token)) {
            _developerFeatures[token] = new SLTFeature(token, properties, required);
        } else {
            throw new Error("Developer feature's token value is incorrect.");
        }
    }

    public function initEmpty():void {
        for (var i:String in _developerFeatures) {
            _activeFeatures[i] = _developerFeatures[i];
        }
    }

    public function initWithData(data:Object):void {
        try {
            _activeFeatures = SLTDeserializer.decodeFeatures(data);
            _experiments = SLTDeserializer.decodeExperiments(data);
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }

    private function validateToken(token:String):Boolean {
        var pattern:RegExp = /[^a-zA-Z0-9._-]/;
        if (null == token || "" == token || -1 != token.search(pattern)) {
            return false;
        }
        return true;
    }
}
}
