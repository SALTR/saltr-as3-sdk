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

internal class SLTDeserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    public function decodeExperiments(data:Object):Vector.<SLTExperiment> {
        var experiments:Vector.<SLTExperiment> = new Vector.<SLTExperiment>();
        var experimentInfo:Array = data.experimentInfo;
        if (experimentInfo != null) {
            for each (var item:Object in experimentInfo) {
                var token:String = item.token;
                //TODO @GSAR: rename to just .partition
                var partition:String = item.partitionName;
                var type:String = item.type;

                //TODO @GSAR: rename and review item.customEventList!!!
                var customEvents:Array = item.customEventList as Array;

                experiments.push(new SLTExperiment(token, partition, type, customEvents));
            }
        }
        return experiments;
    }

    public function decodeLevels(data:Object):Vector.<SLTLevelPack> {
        var levelPacksObject:Object = data.levelPackList;
        var levelPacks:Vector.<SLTLevelPack> = new <SLTLevelPack>[];
        var levels:Vector.<SLTLevel>;
        var levelsObject:Object;
        for each(var levelPack:Object in levelPacksObject) {
            levelsObject = levelPack.levelList;
            levels = new <SLTLevel>[];
            for each (var level:Object in levelsObject) {
                levels.push(new SLTLevel(level.id, level.order, level.url, level.properties, level.version));
            }
            levels.sort(sortByIndex);
            levelPacks.push(new SLTLevelPack(levelPack.token, levelPack.order, levels));
        }
        levelPacks.sort(sortByIndex);
        return levelPacks;
    }

    public function decodeFeatures(data:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        var featuresList:Array = data.featureList;
        if (featuresList != null) {
            for each(var featureObj:Object in featuresList) {
                features[featureObj.token] = new SLTFeature(featureObj.token, featureObj.data);
            }
        }
        return features;
    }
}
}