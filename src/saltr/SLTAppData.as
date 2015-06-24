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
    private var _gameLevelsFeatures:Dictionary;
    private var _experiments:Vector.<SLTExperiment>;


    public function SLTAppData() {
        _activeFeatures = new Dictionary();
        _defaultFeatures = new Dictionary();
        _gameLevelsFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
    }

    public function get defaultFeatures():Dictionary {
        return _defaultFeatures;
    }

    public function get gameLevelsFeatures():Dictionary {
        return _gameLevelsFeatures;
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

    public function getGameLevelsProperties(token:String):SLTLevelData {
        var gameLevelsFeature:SLTFeature = _gameLevelsFeatures[token];
        if (null != gameLevelsFeature) {
            return gameLevelsFeature.properties as SLTLevelData;
        }
        return null;
    }


    public function defineFeature(token:String, properties:*, type:String, required:Boolean):void {
        if (!SLTUtils.validateFeatureToken(token)) {
            throw new Error("feature's token value is incorrect.");
        }

        var feature:SLTFeature = new SLTFeature(token, type, properties, required);
        if (type == SLTConfig.FEATURE_TYPE_GENERIC) {
            _defaultFeatures[token] = feature;
        }
        else if (type == SLTConfig.FEATURE_TYPE_GAME_LEVELS) {
            _gameLevelsFeatures[token] = feature;
        }
    }

    public function initEmpty():void {
        for (var i:String in _defaultFeatures) {
            _activeFeatures[i] = _defaultFeatures[i];
        }
    }

    public function initWithData(data:Object):void {
        try {
            _gameLevelsFeatures = SLTDeserializer.decodeGameLevelsFeatures(data);
            _activeFeatures = SLTDeserializer.decodeGenericFeatures(data);
            _experiments = SLTDeserializer.decodeExperiments(data);
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }
}
}
