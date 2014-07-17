/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {

import flash.utils.Dictionary;

import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;
import saltr.game.canvas2d.SLT2DLevel;
import saltr.game.matching.SLTMatchingLevel;

internal class SLTDeserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    public static function decodeExperiments(rootNode:Object):Vector.<SLTExperiment> {
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

    public static function decodeLevels(rootNode:Object):Vector.<SLTLevelPack> {
        var levelPackNodes:Array = rootNode.levelPacks as Array;
        var levelType:String = SLTLevel.LEVEL_TYPE_MATCHING;

        if (rootNode.hasOwnProperty("levelType")) {
            levelType = rootNode.levelType;
        }

        var levelPacks:Vector.<SLTLevelPack> = new <SLTLevelPack>[];
        var index:int = -1;
        if (levelPackNodes != null) {
            //TODO @GSAR: remove this sort when SALTR confirms correct ordering
            levelPackNodes.sort(sortByIndex);

            for (var i:int = 0, len:int = levelPackNodes.length; i < len; ++i) {
                var levelPackNode:Object = levelPackNodes[i];
                var levelNodes:Array = levelPackNode.levels;

                //TODO @GSAR: remove this sort when SALTR confirms correct ordering
                levelNodes.sort(sortByIndex);

                var levels:Vector.<SLTLevel> = new <SLTLevel>[];
                var packIndex:int = levelPackNode.index;
                for (var j:int = 0, len2:int = levelNodes.length; j < len2; ++j) {
                    ++index;
                    var levelNode:Object = levelNodes[j];

                    //TODO @GSAR: later, leave localIndex only!
                    var localIndex:int = levelNode.hasOwnProperty("localIndex") ? levelNode.localIndex : levelNode.index;
                    levels.push(createLevel(levelType, levelNode.id, index, localIndex, packIndex, levelNode.url, levelNode.properties, levelNode.version));
                }
                levelPacks.push(new SLTLevelPack(levelPackNode.token, packIndex, levels));
            }
        }
        return levelPacks;
    }

    public static function decodeFeatures(rootNode:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        var featureNodes:Array = rootNode.features as Array;
        if (featureNodes != null) {
            var featureNode:Object;
            var token:String;
            var properties:Object;
            var required:Boolean;
            for (var i:int = 0, len:int = featureNodes.length; i < len; ++i) {
                featureNode = featureNodes[i];
                token = featureNode.token;
                //TODO @GSAR: remove "data" check later when API versioning is done.
                properties = featureNode.hasOwnProperty("data") ? featureNode.data : featureNode.properties;
                required = featureNode.required;
                features[token] = new SLTFeature(token, properties, required);
            }
        }
        return features;
    }

    private static function createLevel(levelType:String, id:String, index:int, localIndex:int, packIndex:int, url:String, properties:Object, version:String):SLTLevel {
        switch (levelType) {
            case SLTLevel.LEVEL_TYPE_MATCHING:
                return new SLTMatchingLevel(id, index, localIndex, packIndex, url, properties, version);
                break;
            case SLTLevel.LEVEL_TYPE_2DCANVAS:
                return new SLT2DLevel(id, index, localIndex, packIndex, url, properties, version);
                break;
        }
        return null;
    }

}
}