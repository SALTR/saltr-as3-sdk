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
        var levelPackNodes:Array = rootNode.levelPacks;
        var levelPacks:Vector.<SLTLevelPack> = new <SLTLevelPack>[];
        var levels:Vector.<SLTLevel>;
        var levelNodes:Array;
        var index:int = -1;
        if (levelPackNodes != null) {
            //TODO @GSAR: remove this sort when SALTR confirms correct ordering
            levelPackNodes.sort(sortByIndex);

            for (var i:int = 0, len:int = levelPackNodes.length; i < len; ++i) {
                var levelPackNode:Object = levelPackNodes[i];
                levelNodes = levelPackNode.levels;

                //TODO @GSAR: remove this sort when SALTR confirms correct ordering
                levelNodes.sort(sortByIndex);

                levels = new <SLTLevel>[];
                var packIndex:int = levelPackNode.index;
                for (var j:int = 0, len2:int = levelNodes.length; j < len2; ++j) {
                    ++index;
                    var levelNode:Object = levelNodes[j];
                    var localIndex:int = levelNode.hasOwnProperty("localIndex") ? levelNode.localIndex : levelNode.index;
                    levels.push(new SLTLevel(levelNode.id, index, localIndex, packIndex, levelNode.url, levelNode.properties, levelNode.version));
                }
                levelPacks.push(new SLTLevelPack(levelPackNode.token, packIndex, levels));
            }
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