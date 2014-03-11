/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: daal
 * Date: 6/12/12
 * Time: 2:03 PM
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
