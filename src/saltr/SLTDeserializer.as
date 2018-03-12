/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {

import flash.utils.Dictionary;

import saltr.game.SLTLevel;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTDeserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    saltr_internal static function decodeExperiments(rootNode:Object):Vector.<SLTExperiment> {
        var experiments:Vector.<SLTExperiment> = new <SLTExperiment>[];
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

    saltr_internal static function decodeAndUpdateExistingLevels(rootNode:Object, existingLevels:Vector.<SLTLevel>):Vector.<SLTLevel> {
        var levelsNode:Array = rootNode.levels as Array;
        for (var i:int = 0, length:int = levelsNode.length; i < length; ++i) {
            var levelNode:Object = levelsNode[i];
            var currentSLTLevel:SLTLevel = existingLevels[levelNode.globalIndex];
            currentSLTLevel.update(levelNode.version, levelNode.url);
        }
        return existingLevels;
    }

    saltr_internal static function decodeAndCreateNewLevels(rootNode:Object):Vector.<SLTLevel> {
        var levelsNode:Array = rootNode.levels as Array;
        var levels:Vector.<SLTLevel> = new <SLTLevel>[];
        for (var i:int = 0, length:int = levelsNode.length; i < length; ++i) {
            var levelNode:Object = levelsNode[i];
            var level:SLTLevel = new SLTLevel(levelNode.globalIndex, levelNode.localIndex, levelNode.packIndex, levelNode.url, levelNode.levelToken, levelNode.packToken, levelNode.version);
            levels.push(level);
        }
        return levels;
    }

    saltr_internal static function decodeAndInitFeatures(snapshotAppdataNode:Object, features:Dictionary):Dictionary {
        var featureNodes:Array = snapshotAppdataNode.features as Array;
        if (featureNodes != null) {
            for (var i:int = 0, len:int = featureNodes.length; i < len; ++i) {
                var featureNode:Object = featureNodes[i];
                var token:String = featureNode.token;
                var featureType:String = featureNode.type;
                var version:String = featureNode.version;
                var isRequired:Boolean = featureNode.required;

                var parsedBody:Object = JSON.parse(featureNode.properties);

                switch (featureType) {
                    case SLTFeatureType.GENERIC :
                        features[token] = new SLTFeature(token, featureType, version, parsedBody, isRequired);
                        break;

                    case SLTFeatureType.LEVEL_COLLECTION :
                        features[token] = new SLTFeature(token, featureType, version, new SLTLevelCollectionBody(parsedBody), isRequired);
                        break;

                    default:
                        trace("SALTR parsing unknown feature type.");
                }
            }
        }
        return features;
    }


    saltr_internal static function decodeAndUpdateFeatures(rootNode:Object, sltFeatureMap:Dictionary):Dictionary {
        var featureNodes:Array = rootNode.features as Array;

        if (featureNodes != null) {

            var featureNodeMap:Dictionary = new Dictionary();
            for (var i:int = 0, len:int = featureNodes.length; i < len; ++i) {
                var node:Object = featureNodes[i];
                featureNodeMap[node.token] = node;
            }

            for each (var sltFeature:SLTFeature in sltFeatureMap) {
                var token:String = sltFeature.token;
                var featureType:String = sltFeature.type;
                var featureNode:Object = featureNodeMap[token];

                if (featureNode != null) {
                    var featureNodeVersion:String = featureNode.version;
                    sltFeature.disabled = false;
                    if (sltFeature.version != featureNodeVersion) {
                        switch (featureType) {
                            case SLTFeatureType.GENERIC :
                                sltFeature.update(featureNodeVersion, JSON.parse(featureNode.properties));
                                break;

                            case SLTFeatureType.LEVEL_COLLECTION :
                                SLTLevelCollectionBody(sltFeature.body).updateLevels(JSON.parse(featureNode.properties));
                                sltFeature.update(featureNodeVersion);
                                break;

                            default:
                                trace("SALTR parsing unknown feature type.");
                        }
                    }

                } else if (sltFeature.isRequired == false) {
                    sltFeature.disabled = true;
                }


            }
        }
        return sltFeatureMap;
    }
}
}