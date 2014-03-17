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
                //TODO @daal. supporting partitionName(old) and partition.
                var partition:String = experimentInfoNode.hasOwnProperty("partition") ? experimentInfoNode.partition : experimentInfoNode.partitionName;
                var type:String = experimentInfoNode.type;

                //TODO @GSAR: rename and review item.customEventList!!!
                var customEvents:Array = experimentInfoNode.customEventList as Array;

                experiments.push(new SLTExperiment(token, partition, type, customEvents));
            }
        }
        return experiments;
    }

    public static function decodeLevels(rootNode:Object):Vector.<SLTLevelPack> {
        //TODO @daal. supporting levePackList(old) and levelPacks
        var levelPackNodes:Object = rootNode.hasOwnProperty("levelPacks") ? rootNode.levelPacks : rootNode.levelPackList;
        var levelPacks:Vector.<SLTLevelPack> = new <SLTLevelPack>[];
        var levels:Vector.<SLTLevel>;
        var levelNodes:Object;
        for each(var levelPackNode:Object in levelPackNodes) {
            //TODO @daal. supporting levelList(old) and levels.
            levelNodes = levelPackNode.hasOwnProperty("levels") ? levelPackNode.levels : levelPackNode.levelList;
            levels = new <SLTLevel>[];
            for each (var levelNode:Object in levelNodes) {
                //TODO @daal. supporting order(old) and index.
                var levelIndex : int = levelNode.hasOwnProperty("index") ? levelNode.index : levelNode.order;
                levels.push(new SLTLevel(levelNode.id, levelIndex, levelNode.url, levelNode.properties, levelNode.version));
            }
            levels.sort(sortByIndex);
            //TODO @daal. supporting order(old) and index.
            var index : int = levelPackNode.hasOwnProperty("index") ? levelPackNode.index : levelPackNode.order;
            levelPacks.push(new SLTLevelPack(levelPackNode.token, index, levels));
        }
        levelPacks.sort(sortByIndex);
        return levelPacks;
    }

    public static function decodeFeatures(rootNode:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        //TODO @daal. supporting featureList(old) and features.
        var featureNodes:Array = rootNode.hasOwnProperty("features") ? rootNode.features : rootNode.featureList;
        if (featureNodes != null) {
            for each(var featureNode:Object in featureNodes) {
                features[featureNode.token] = new SLTFeature(featureNode.token, featureNode.data);
            }
        }
        return features;
    }
}
}