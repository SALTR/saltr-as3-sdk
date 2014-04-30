/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: daal
 * Date: 6/12/12
 * Time: 2:02 PM
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
        var experimentInfoNodes:Array = rootNode.experimentInfo;
        if (experimentInfoNodes != null) {
            for each (var experimentInfoNode:Object in experimentInfoNodes) {
                var token:String = experimentInfoNode.token;
                var partition:String = experimentInfoNode.partition;
                var type:String = experimentInfoNode.type;
                var customEvents:Array = experimentInfoNode.customEventList as Array;

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
        for each(var levelPackNode:Object in levelPackNodes) {
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
        return levelPacks;
    }

    public static function decodeFeatures(rootNode:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        var featureNodes:Array = rootNode.features;
        if (featureNodes != null) {
            for each(var featureNode:Object in featureNodes) {
                features[featureNode.token] = new SLTFeature(featureNode.token, featureNode.data);
            }
        }
        return features;
    }
}
}