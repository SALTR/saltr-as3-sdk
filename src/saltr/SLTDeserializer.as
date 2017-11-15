/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {

import de.polygonal.ds.HashMap;
import de.polygonal.ds.Map;

import flash.utils.Dictionary;

import saltr.game.SLTLevel;
import saltr.lang.SLTLocale;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTDeserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    saltr_internal static function decodeExperiments(rootNode:Object):Vector.<SLTExperiment> {
        var experiments:Vector.<SLTExperiment> = new Vector.<SLTExperiment>();
        var experimentNodes:Array = rootNode.experiments as Array;
        if (experimentNodes != null) {
            for (var i:int = 0, len:int = experimentNodes.length; i < len; ++i) {
                var experimentNode:Object = experimentNodes[i];
                var token:String = experimentNode.token;
                var partition:String = experimentNode.partition;
                var experimentType:String = experimentNode.type;
                var customEvents:Array = experimentNode.customEventList as Array;
                experiments.push(new SLTExperiment(token, partition, experimentType, customEvents));
            }
        }
        return experiments;
    }

    saltr_internal static function decodeLevels(rootNode:Object):Vector.<SLTLevel> {
        var levelsNode:Array = rootNode.levels as Array;
        var levels:Vector.<SLTLevel> = new <SLTLevel>[];
        for (var i:int = 0, length:int = levelsNode.length; i < length; ++i) {
            var levelNode:Object = levelsNode[i];
            var level:SLTLevel = new SLTLevel(levelNode.globalIndex, levelNode.localIndex, levelNode.packIndex, levelNode.url, levelNode.levelToken, levelNode.packToken, levelNode.version);
            levels.push(level);
        }
        return levels;
    }


    saltr_internal static function decodeLocalization(rootNode:Object):Dictionary {
        var locales:Dictionary = new Dictionary();
        for (var key:String in rootNode) {
            var localeNode:Object = rootNode[key];
            var locale:SLTLocale = new SLTLocale(localeNode.url, localeNode.version);
            locales[key] =  locale;
        }
        return locales;
    }

    saltr_internal static function decodeFeatures(rootNode:Object, decodeFeatureType:String, existingFeatures:Dictionary = null):Dictionary {
        var features:Dictionary = new Dictionary();
        var featureNodes:Array = rootNode.features as Array;
        if (featureNodes != null) {
            for (var i:int = 0, len:int = featureNodes.length; i < len; ++i) {
                var featureNode:Object = featureNodes[i];
                var token:String = featureNode.token;
                var featureType:String = featureNode.type;
                var version:String = featureNode.version;
                var required:Boolean = featureNode.required;
                var canUseExistingFeatureProperties:Boolean = existingFeatures && existingFeatures[token] && existingFeatures[token].version == version;

                if (SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION == decodeFeatureType && SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION == featureType) {
                    var levelData:SLTLevelData = new SLTLevelData();
                    if (canUseExistingFeatureProperties) {
                        levelData = existingFeatures[token].properties;
                    } else {
                        levelData.initWithData(JSON.parse(featureNode.properties));
                        levelData.sortLevel();
                    }
                    features[token] = new SLTFeature(token, featureType, version, levelData, required);
                } else if (SLTConfig.FEATURE_TYPE_LOCALIZATION == decodeFeatureType && SLTConfig.FEATURE_TYPE_LOCALIZATION == featureType) {
                    var localizationData:SLTLocalizationData = new SLTLocalizationData();
                    localizationData.initWithData(JSON.parse(featureNode.properties));
                    features[token] = new SLTFeature(token, featureType, version, localizationData, required);
                } else if (SLTConfig.FEATURE_TYPE_GENERIC == decodeFeatureType && SLTConfig.FEATURE_TYPE_GENERIC == featureType) {
                    var properties:Object = canUseExistingFeatureProperties ? existingFeatures[token].properties : JSON.parse(featureNode.properties);
                    features[token] = new SLTFeature(token, featureType, version, properties, required);
                }
            }
        }
        return features;
    }

    saltr_internal static function getFeature(rootNode:Object, featureToken:String, featureType:String):Object {
        var feature:Object = null;
        var featureNodes:Array = rootNode.features as Array;
        if (null != featureNodes) {
            for (var i:int = 0, length:int = featureNodes.length; i < length; ++i) {
                var featureNode:Object = featureNodes[i];
                if (featureToken == featureNode.token && featureType == featureNode.type) {
                    feature = featureNode;
                    break;
                }
            }
        }
        return feature;
    }

    /*
     Provides cached level version from level_versions.json
     rootNode - level_versions.json
     globalIndex - The level global identifier
     */
    saltr_internal static function getCachedLevelVersion(rootNode:Object, globalIndex:int):String {
        var version:String = null;
        var container:Array = rootNode as Array;
        if (null != container) {
            for (var i:int = 0, length:int = container.length; i < length; ++i) {
                var cachedLevelNode:Object = container[i];
                if (globalIndex == cachedLevelNode.globalIndex) {
                    version = cachedLevelNode.version;
                    break;
                }
            }
        }
        return version;
    }

}
}