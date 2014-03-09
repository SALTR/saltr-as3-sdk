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

    //TODO @GSAR: why these methods are not static?
    public function decodeExperiments(rootNode:Object):Vector.<SLTExperiment> {
        var experiments:Vector.<SLTExperiment> = new Vector.<SLTExperiment>();
        var experimentInfoNodes:Array = rootNode.experimentInfo;
        if (experimentInfoNodes != null) {
            for each (var experimentInfoNode:Object in experimentInfoNodes) {
                var token:String = experimentInfoNode.token;
                //TODO @GSAR: rename to just .partition
                var partition:String = experimentInfoNode.partitionName;
                var type:String = experimentInfoNode.type;

                //TODO @GSAR: rename and review item.customEventList!!!
                var customEvents:Array = experimentInfoNode.customEventList as Array;

                experiments.push(new SLTExperiment(token, partition, type, customEvents));
            }
        }
        return experiments;
    }

    public function decodeLevels(rootNode:Object):Vector.<SLTLevelPack> {
        //TODO @GSAR: why not rename .levelPackList to .levelPacks? ask TYOM!
        var levelPackNodes:Object = rootNode.levelPackList;
        var levelPacks:Vector.<SLTLevelPack> = new <SLTLevelPack>[];
        var levels:Vector.<SLTLevel>;
        var levelNodes:Object;
        for each(var levelPackNode:Object in levelPackNodes) {
            //TODO @GSAR: why not rename .levelList to .levels? ask TYOM!
            levelNodes = levelPackNode.levelList;
            levels = new <SLTLevel>[];
            for each (var levelNode:Object in levelNodes) {
                levels.push(new SLTLevel(levelNode.id, levelNode.order, levelNode.url, levelNode.properties, levelNode.version));
            }
            levels.sort(sortByIndex);
            levelPacks.push(new SLTLevelPack(levelPackNode.token, levelPackNode.order, levels));
        }
        levelPacks.sort(sortByIndex);
        return levelPacks;
    }

    public function decodeFeatures(rootNode:Object):Dictionary {
        var features:Dictionary = new Dictionary();
        //TODO @GSAR: why not rename .featureList to .features? ask TYOM!
        var featureNodes:Array = rootNode.featureList;
        if (featureNodes != null) {
            for each(var featureNode:Object in featureNodes) {
                features[featureNode.token] = new SLTFeature(featureNode.token, featureNode.data);
            }
        }
        return features;
    }
}
}