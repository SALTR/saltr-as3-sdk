/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.utils.Dictionary;

import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTAppData {

    private var _activeFeatures:Dictionary;
    private var _defaultFeatures:Dictionary;
    private var _gameLevelsFeatures:Dictionary;
    private var _defaultGameLevelsFeatures:Dictionary;
    private var _experiments:Vector.<SLTExperiment>;


    public function SLTAppData() {
        _activeFeatures = new Dictionary();
        _defaultFeatures = new Dictionary();
        _gameLevelsFeatures = new Dictionary();
        _defaultGameLevelsFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
    }

    saltr_internal function get activeFeatures():Dictionary {
        return _activeFeatures;
    }

    saltr_internal function get defaultFeatures():Dictionary {
        return _defaultFeatures;
    }

    saltr_internal function get gameLevelsFeatures():Dictionary {
        return _gameLevelsFeatures;
    }

    saltr_internal function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    saltr_internal function getActiveFeatureTokens():Vector.<String> {
        var tokens:Vector.<String> = new Vector.<String>();
        for each(var feature:SLTFeature in _activeFeatures) {
            tokens.push(feature.token);
        }
        return tokens;
    }

    saltr_internal function getFeatureProperties(token:String):Object {
        var activeFeature:SLTFeature = _activeFeatures[token];
        if (activeFeature != null && activeFeature.isValid) {
            return activeFeature.properties;
        } else {
            var devFeature:SLTFeature = _defaultFeatures[token];
            if (devFeature != null && devFeature.required) {
                return devFeature.properties;
            }
        }
        return null;
    }

    saltr_internal function getGameLevelsProperties(token:String):SLTLevelData {
        var gameLevelsFeature:SLTFeature = _gameLevelsFeatures[token];
        if (null != gameLevelsFeature) {
            return gameLevelsFeature.properties as SLTLevelData;
        } else {
            var defaultGameLevelFeature:SLTFeature = _defaultGameLevelsFeatures[token];
            if (defaultGameLevelFeature != null) {
                return defaultGameLevelFeature.properties as SLTLevelData;
            }
        }
        return null;
    }


    saltr_internal function defineFeature(token:String, properties:*, type:String, required:Boolean):void {
        if (!SLTUtils.validateFeatureToken(token)) {
            throw new Error("feature's token value is incorrect.");
        }

        var feature:SLTFeature = new SLTFeature(token, type, properties, required);
        if (type == SLTConfig.FEATURE_TYPE_GENERIC) {
            _defaultFeatures[token] = feature;
        }
        else if (type == SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION) {
            _defaultGameLevelsFeatures[token] = feature;
        }
    }

    saltr_internal function initEmpty():void {
        for (var i:String in _defaultFeatures) {
            _activeFeatures[i] = _defaultFeatures[i];
        }
        for (var i:String in _defaultGameLevelsFeatures) {
            _gameLevelsFeatures[i] = _defaultGameLevelsFeatures[i];
        }
    }

    saltr_internal function initDefaultFeatures(data:Object):void {
        try {
            _defaultGameLevelsFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION);
            _defaultFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_GENERIC);
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }

    saltr_internal function initWithData(data:Object):void {
        try {
            _gameLevelsFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION);
            _activeFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_GENERIC);
            _experiments = SLTDeserializer.decodeExperiments(data);
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }
}
}