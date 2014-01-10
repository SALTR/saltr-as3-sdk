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

//TODO @GSAR: make this internal!
public class Deserializer {

    private static function sortByIndex(p1:Object, p2:Object):int {
        return p1.index - p2.index;
    }

    //TODO: my be map is can be more flexible
    private var _features:Vector.<Feature>;
    private var _experiments:Vector.<Experiment>;
    private var _levelPackStructures:Vector.<LevelPackStructure>;

    public function Deserializer() {
        _features = new Vector.<Feature>();
        _experiments = new Vector.<Experiment>();
    }

    public function get features():Vector.<Feature> {
        return _features;
    }

    public function get levelPackStructures():Vector.<LevelPackStructure> {
        return _levelPackStructures;
    }

    public function get experiments():Vector.<Experiment> {
        return _experiments;
    }

    public function getFeatureByToken(token:String):Feature {
        for (var i:int = 0, len:int = _features.length; i < len; ++i) {
            if (_features[i].token == token) {
                return _features[i];
            }
        }
        return null;
    }

    public function decode(data:Object):void {
        if (data == null) {
            return;
        }

        clearData();
        decodeFeatures(data);
        decodeExperimentInfo(data);
        decodeLevels(data);
    }

    private function decodeExperimentInfo(data:Object):void {
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
                _experiments.push(experiment);
            }
        }
    }

    private function decodeLevels(data:Object):void {
        var levelPacksObject:Object = data.levelPackList;
        _levelPackStructures = new <LevelPackStructure>[];
        var levelStructures:Vector.<LevelStructure>;
        var levelsObject:Object;
        for each(var levelPack:Object in levelPacksObject) {
            levelsObject = levelPack.levelList;
            levelStructures = new <LevelStructure>[];
            for each (var level:Object in levelsObject) {
                levelStructures.push(new LevelStructure(level.id, level.order, level.url, level.properties, level.version));
            }
            levelStructures.sort(sortByIndex);
            _levelPackStructures.push(new LevelPackStructure(levelPack.token, levelPack.order, levelStructures));
        }
        _levelPackStructures.sort(sortByIndex);
    }

    private function decodeFeatures(data:Object):void {
        var featuresList:Array = data.featureList;
        if (featuresList != null) {
            var feature:Feature;
            for each(var featureObj:Object in featuresList) {
                feature = new Feature(featureObj.token, featureObj.data);
                _features.push(feature);
            }
        }
    }

    private function clearData():void {
        if (_features) {
            _features.length = 0;
        }
        if (_experiments) {
            _experiments.length = 0;
        }
        if (_levelPackStructures) {
            _levelPackStructures.length = 0;
        }
    }
}
}
