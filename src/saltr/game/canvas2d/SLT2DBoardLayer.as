/**
 * Created by GSAR on 7/11/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTBoardLayer;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLT2DBoardLayer class represents the game 2D board's layer.
 * @private
 */
internal class SLT2DBoardLayer extends SLTBoardLayer {
    private var _assetRules:Array;

    /**
     * Class constructor.
     * @param token The layer's identifier.
     * @param layerIndex The layer's ordering index.
     * @param assetRules The array of asset rules.
     */
    public function SLT2DBoardLayer(token:String, layerIndex:int, assetRules:Array) {
        super(token, layerIndex);
        _assetRules = assetRules;
    }

    saltr_internal function get assetRules():Array {
        return _assetRules;
    }
}
}
