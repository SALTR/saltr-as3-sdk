/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 4/12/12
 * Time: 7:27 PM
 */
package saltr.parser.game {
internal class SLTChunkAssetInfo {

    private var _assetId:String;
    private var _count:uint;
    private var _ratio:Number;
    private var _stateId:String;

    public function SLTChunkAssetInfo(assetId:String, count:uint, ratio:Number, stateId:String) {

        _assetId = assetId;
        _count = count;
        _ratio = ratio;
        _stateId = stateId;
    }

    public function get assetId():String {
        return _assetId;
    }

    public function get count():uint {
        return _count;
    }

    public function get ratio():Number {
        return _ratio;
    }

    public function get stateId():String {
        return _stateId;
    }
}
}
