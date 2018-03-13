/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import flash.utils.Dictionary;

import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTAppData {

    private var _activeFeatures:Dictionary;
    private var _experiments:Vector.<SLTExperiment>;
    private var _snapshotId:String;

    public function SLTAppData() {
        _activeFeatures = new Dictionary();
        _experiments = new <SLTExperiment>[];
    }

    saltr_internal function get activeFeatures():Dictionary {
        return _activeFeatures;
    }

    saltr_internal function get experiments():Vector.<SLTExperiment> {
        return _experiments;
    }

    saltr_internal function getFeatureBody(token:String):Object {
        var activeFeature:SLTFeature = _activeFeatures[token];
        if (activeFeature != null && activeFeature.isValid && !activeFeature.disabled) {
            return activeFeature.body;
        }
        return null;
    }

    saltr_internal function getLevelCollectionBody(token:String):SLTLevelCollectionBody {
        var levelCollectionFeature:SLTFeature = _activeFeatures[token];
        if (levelCollectionFeature != null) {
            return levelCollectionFeature.body as SLTLevelCollectionBody;
        }
        return null;
    }

    saltr_internal function defineFeature(token:String, body:*, type:String, required:Boolean):void {
        if (!SLTUtils.validateFeatureToken(token)) {
            throw new Error("feature's token value is incorrect.");
        }

        _activeFeatures[token] = new SLTFeature(token, type, body, required);
    }

    saltr_internal function initFeatures(data:Object):void {
        try {
            SLTDeserializer.decodeAndInitFeatures(data, _activeFeatures);
            _snapshotId = data.snapshotId;
        } catch (e:Error) {
            throw new Error("AppData parse error");
        }
    }

    saltr_internal function initWithData(data:Object):void {
        _activeFeatures = SLTDeserializer.decodeAndUpdateFeatures(data, _activeFeatures);
        _experiments = SLTDeserializer.decodeExperiments(data);
    }

    public function get snapshotId():String {
        return _snapshotId;
    }
}
}