/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
public class SLTExperiment {
    public static const SPLIT_TEST_TYPE_FEATURE:String = "FEATURE";
    public static const SPLIT_TEST_TYPE_LEVEL_PACK:String = "LEVEL_PACK";

    private var _partition:String;
    private var _token:String;
    private var _type:String;
    private var _customEvents:Array;

    public function SLTExperiment(token:String, partition:String, type:String, customEvents:Array) {
        _token = token;
        _partition = partition;
        _type = type;
        _customEvents = customEvents;
    }

    public function get partition():String {
        return _partition;
    }

    public function get token():String {
        return _token;
    }

    public function get type():String {
        return _type;
    }

    public function get customEvents():Array {
        return _customEvents;
    }

}
}
