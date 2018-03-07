/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.utils.Dictionary;

import saltr.game.SLTLevel;
import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTAppData {

    private var _activeFeatures:Dictionary;
    private var _defaultFeatures:Dictionary;
    private var _levelCollectionFeatures:Dictionary;
    private var _defaultLevelCollectionFeatures:Dictionary;
    private var _experiments:Vector.<SLTExperiment>;
    private var _snapshotId:String;

    public function SLTAppData() {
        _activeFeatures = new Dictionary();
        _defaultFeatures = new Dictionary();
        _levelCollectionFeatures = new Dictionary();
        _defaultLevelCollectionFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
    }

    saltr_internal function get activeFeatures():Dictionary {
        return _activeFeatures;
    }

    saltr_internal function get defaultFeatures():Dictionary {
        return _defaultFeatures;
    }

    saltr_internal function get levelCollectionFeatures():Dictionary {
        return _levelCollectionFeatures;
    }

    saltr_internal function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    saltr_internal function getActiveFeatureTokens():Vector.<String> {
        var tokens:Vector.<String> = new <String>[];
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

    saltr_internal function getDefaultGameLevels(token:String):Vector.<SLTLevel> {
        return _defaultLevelCollectionFeatures[token].properties.allLevels;
    }

    saltr_internal function getLevelCollectionProperties(token:String):SLTLevelCollectionProperties {
        var levelCollectionFeature:SLTFeature = _levelCollectionFeatures[token];
        if (null != levelCollectionFeature) {
            return levelCollectionFeature.properties as SLTLevelCollectionProperties;
        } else {
            var defaultLevelCollection:SLTFeature = _defaultLevelCollectionFeatures[token];
            if (defaultLevelCollection != null) {
                return defaultLevelCollection.properties as SLTLevelCollectionProperties;
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
            _defaultLevelCollectionFeatures[token] = feature;
        }
    }

    saltr_internal function initEmpty():void {
        for (var i:String in _defaultFeatures) {
            _activeFeatures[i] = _defaultFeatures[i];
        }

        for (var j:String in _defaultLevelCollectionFeatures) {
            _levelCollectionFeatures[j] = _defaultLevelCollectionFeatures[j];
        }
    }

    saltr_internal function initDefaultFeatures(data:Object):void {
        try {
            _defaultLevelCollectionFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION, _defaultLevelCollectionFeatures);
            _defaultFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_GENERIC, _defaultFeatures);
            _snapshotId = data.snapshotId;
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }

    saltr_internal function initWithData(data:Object):void {
        try {
            _levelCollectionFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION, _levelCollectionFeatures);
            _activeFeatures = SLTDeserializer.decodeFeatures(data, SLTConfig.FEATURE_TYPE_GENERIC, _activeFeatures);
            _experiments = SLTDeserializer.decodeExperiments(data);
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }

    public function get snapshotId():String {
        return _snapshotId;
    }
}
}