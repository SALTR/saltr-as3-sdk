/**
 * Created by TIGR on 3/23/2015.
 */
package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTChunkAssetDatum {
    private var _assetId:String;
    private var _assetToken:String;
    private var _stateId:String;

    public function SLTChunkAssetDatum(assetId:String, stateId:String, assetMap:Dictionary) {
        _assetId = assetId;
        _assetToken = getAssetTokenById(_assetId, assetMap);
        _stateId = stateId;
    }

    saltr_internal function get assetId():String {
        return _assetId;
    }

    saltr_internal function get assetToken():String {
        return _assetToken;
    }

    saltr_internal function get stateId():String {
        return _stateId;
    }

    private function getAssetTokenById(assetId:String, assetMap:Dictionary):String {
        var asset:SLTAsset = assetMap[assetId] as SLTAsset;
        return asset.token;
    }
}
}
