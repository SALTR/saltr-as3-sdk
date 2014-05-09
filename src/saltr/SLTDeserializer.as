/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {

import flash.utils.Dictionary;

import saltr.parser.game.SLTLevel;
import saltr.parser.game.SLTLevelPack;

internal class SLTDeserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    public static function decodeExperiments(rootNode:Object):Vector.<SLTExperiment> {
        var experiments:Vector.<SLTExperiment> = new Vector.<SLTExperiment>();
        var experimentNodes:Array = rootNode.hasOwnProperty("experiments") ? rootNode["experiments"] : rootNode["experimentInfo"];
        if (experimentNodes != null) {
            for (var i:int = 0, len:int = experimentNodes.length; i < len; ++i) {
                var experimentNode:Object = experimentNodes[i];
                var token:String = experimentNode.token;
                var partition:String = experimentNode.partition;
                var type:String = experimentNode.type;
                var customEvents:Array = experimentNode.customEventList as Array;
                experiments.push(new SLTExperiment(token, partition, type, customEvents));
            }
        }
        return experiments;
    }

    public static function decodeLevels(rootNode:Object):Vector.<SLTLevelPack> {
        var levelPackNodes:Object = rootNode.levelPacks;
        var levelPacks:Vector.<SLTLevelPack> = new <SLTLevelPack>[];
        var levels:Vector.<SLTLevel>;
        var levelNodes:Object;
        if (levelPackNodes != null) {
            for (var i:int = 0, len:int = levelPackNodes.length; i < len; ++i) {
                var levelPackNode:Object = levelPackNodes[i];
                levelNodes = levelPackNode.levels;
                levels = new <SLTLevel>[];
                for each (var levelNode:Object in levelNodes) {
                    var levelIndex:int = levelNode.index;
                    levels.push(new SLTLevel(levelNode.id, levelIndex, levelNode.url, levelNode.properties, levelNode.version));
                }
                levels.sort(sortByIndex);
                var index:int = levelPackNode.index;
                levelPacks.push(new SLTLevelPack(levelPackNode.token, index, levels));
            }
            levelPacks.sort(sortByIndex);
        }
        return levelPacks;
    }

    public static function decodeFeatures(rootNode:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        var featureNodes:Array = rootNode.features;
        if (featureNodes != null) {
            for (var i:int = 0, len:int = featureNodes.length; i < len; ++i) {
                var featureNode:Object = featureNodes[i];
                features[featureNode.token] = new SLTFeature(featureNode.token, featureNode.data, featureNode.required);
            }
        }
        return features;
    }
}
}