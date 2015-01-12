/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {

/**
 * The SLTExperiment class provides the currently running experiment data.
 * It is possible to A/B test any feature included in the game AND/OR different levels, level packs.
 */
public class SLTExperiment {

    /**
     * Specifies the Feature type for the experiment.
     */
    public static const TYPE_FEATURE:String = "FEATURE";

    /**
     * Specifies the LevelPack type for the experiment.
     */
    public static const TYPE_LEVEL_PACK:String = "LEVEL_PACK";

    private var _partition:String;
    private var _token:String;
    private var _type:String;
    private var _customEvents:Array;

    /**
     * Class constructor.
     * @param token The unique identifier of the experiment.
     * @param partition The letter of the partition in which the user included in (A, B, C, etc.).
     * @param type The type of the experiment (Feature or LevelPack).
     * @param customEvents The array of comma separated event names for which A/B test data should be send.
     */
    public function SLTExperiment(token:String, partition:String, type:String, customEvents:Array) {
        _token = token;
        _partition = partition;
        _type = type;
        _customEvents = customEvents;
    }

    /**
     * The letter of the partition in which the user included in (A, B, C, etc.).
     */
    public function get partition():String {
        return _partition;
    }

    /**
     * The unique identifier of the experiment.
     */
    public function get token():String {
        return _token;
    }

    /**
     * The type of the experiment (Feature or LevelPack).
     */
    public function get type():String {
        return _type;
    }

    /**
     * The array of comma separated event names for which A/B test data should be send.
     */
    public function get customEvents():Array {
        return _customEvents;
    }

}
}
