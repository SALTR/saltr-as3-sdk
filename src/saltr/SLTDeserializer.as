/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {

import flash.utils.Dictionary;

import saltr.game.SLTLevel;

use namespace saltr_internal;

public class SLTDeserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    saltr_internal static function decodeExperiments(rootNode:Object):Vector.<SLTExperiment> {
        var experiments:Vector.<SLTExperiment> = new Vector.<SLTExperiment>();
        var experimentNodes:Array = rootNode.experiments as Array;
        if (experimentNodes != null) {
            var experimentNode:Object;
            var token:String;
            var partition:String;
            var experimentType:String;
            var customEvents:Array;
            for (var i:int = 0, len:int = experimentNodes.length; i < len; ++i) {
                experimentNode = experimentNodes[i];
                token = experimentNode.token;
                partition = experimentNode.partition;
                experimentType = experimentNode.type;
                customEvents = experimentNode.customEventList as Array;
                experiments.push(new SLTExperiment(token, partition, experimentType, customEvents));
            }
        }
        return experiments;
    }

    saltr_internal static function decodeLevels(rootNode:Object):Vector.<SLTLevel> {
        var levelType:String = SLTLevel.LEVEL_TYPE_MATCHING;

        if (rootNode.hasOwnProperty("levelType")) {
            levelType = rootNode.levelType;
        }

        var levelsNode:Array = rootNode.levels as Array;
        var levels:Vector.<SLTLevel> = new <SLTLevel>[];
        for (var i:int = 0, length:int = levelsNode.length; i < length; ++i) {
            var levelNode:Object = levelsNode[i];
            var level:SLTLevel = new SLTLevel(levelNode.globalIndex, levelNode.localIndex, levelNode.packIndex, levelNode.url, levelNode.version, levelType);
            levels.push(level);
        }
        return levels;
    }

    saltr_internal static function decodeGameLevelsFeatures(rootNode:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        var featureNodes:Array = rootNode.features as Array;
        if (featureNodes != null) {
            for (var i:int = 0, len:int = featureNodes.length; i < len; ++i) {
                var featureNode:Object = featureNodes[i];
                var token:String = featureNode.token;
                var type:String = featureNode.featureType;
                var properties:Object = featureNode.properties;
                var required : Boolean = featureNode.required;
                if (SLTConfig.FEATURE_TYPE_GAME_LEVELS == type) {
                    var levelData:SLTLevelData = new SLTLevelData();
                    levelData.initWithData(properties);
                    features[token] = new SLTFeature(token, type, levelData, required);
                }
            }
        }
        return features;
    }

    saltr_internal static function decodeGenericFeatures(rootNode:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        var featureNodes:Array = rootNode.features as Array;
        if (featureNodes != null) {
            for (var i:int = 0, len:int = featureNodes.length; i < len; ++i) {
                var featureNode:Object = featureNodes[i];
                var token:String = featureNode.token;
                var type:String = featureNode.featureType;
                var properties:Object = featureNode.properties;
                var required:Boolean = featureNode.required;
                if (SLTConfig.FEATURE_TYPE_GENERIC == type) {
                    features[token] = new SLTFeature(token, type, properties, required);
                }
            }
        }
        return features;
    }

    saltr_internal static function getFeature(rootNode:Object, featureToken:String, featureType:String):Object {
        var feature:Object = null;
        var featureNodes:Array = rootNode.features as Array;
        if (null != featureNodes) {
            var len:int = featureNodes.length;
            for (var i:int = 0, len:int = len; i < len; ++i) {
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
            for (var i:int = 0; i < container.length; ++i) {
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