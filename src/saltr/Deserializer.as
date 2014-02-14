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

internal class Deserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    public function decodeExperiments(data : Object) : Vector.<Experiment> {
        var experiments : Vector.<Experiment> = new Vector.<Experiment>();
        var experimentInfo:Array = data.experimentInfo;
        if (experimentInfo != null) {
            for each (var item:Object in experimentInfo) {
                var experiment:Experiment = new Experiment();
                experiment.token = item.token;
                //TODO @GSAR: rename to just .partition
                experiment.partition = item.partitionName;
                experiment.type = item.type;

                //TODO @GSAR: rename and review item.customEventList!!!
                experiment.customEvents = item.customEventList as Array;
                experiments.push(experiment);
            }
        }
        return experiments;
    }

    public function decodeLevels(data : Object) : Vector.<LevelPackStructure> {
        var levelPacksObject:Object = data.levelPackList;
        var levelPackStructures : Vector.<LevelPackStructure> = new <LevelPackStructure>[];
        var levelStructures:Vector.<LevelStructure>;
        var levelsObject:Object;
        for each(var levelPack:Object in levelPacksObject) {
            levelsObject = levelPack.levelList;
            levelStructures = new <LevelStructure>[];
            for each (var level:Object in levelsObject) {
                levelStructures.push(new LevelStructure(level.id, level.order, level.url, level.properties, level.version));
            }
            levelStructures.sort(sortByIndex);
            levelPackStructures.push(new LevelPackStructure(levelPack.token, levelPack.order, levelStructures));
        }
        levelPackStructures.sort(sortByIndex);
        return levelPackStructures;
    }

    public function decodeFeatures(data : Object) : Dictionary {
        var features : Dictionary = new Dictionary();
        var featuresList:Array = data.featureList;
        if (featuresList != null) {
            for each(var featureObj:Object in featuresList) {
                features[featureObj.token] = new Feature(featureObj.token, featureObj.data);
            }
        }
        return features;
    }
}
}