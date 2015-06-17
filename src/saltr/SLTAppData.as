/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.utils.Dictionary;

import saltr.utils.SLTUtils;

use namespace saltr_internal;

public class SLTAppData {

    private var _activeFeatures:Dictionary;
    private var _defaultFeatures:Dictionary;
    private var _experiments:Vector.<SLTExperiment>;


    public function SLTAppData() {
        _activeFeatures = new Dictionary();
        _defaultFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
    }

    public function get activeFeatures():Dictionary {
        return _activeFeatures;
    }

    public function get defaultFeatures():Dictionary {
        return _defaultFeatures;
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
            var devFeature:SLTFeature = _defaultFeatures[token];
            if (devFeature != null && devFeature.required) {
                return devFeature.properties;
            }
        }
        return null;
    }

    public function defineGenericFeature(token:String, properties:Object, required:Boolean):void {
        if (SLTUtils.validateFeatureToken(token)) {
            _defaultFeatures[token] = new SLTFeature(token, SLTConfig.FEATURE_TYPE_GENERIC, properties, required);
        } else {
            throw new Error("Default feature's token value is incorrect.");
        }
    }

    public function initEmpty():void {
        for (var i:String in _defaultFeatures) {
            _activeFeatures[i] = _defaultFeatures[i];
        }
    }

    public function initWithData(data:Object):void {
        try {
            _activeFeatures = SLTDeserializer.decodeGenericFeatures(data);
            _experiments = SLTDeserializer.decodeExperiments(data);
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }
}
}
