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
public class SLT2DBoardLayer extends SLTBoardLayer {

    private var _assetInstances:Vector.<SLT2DAssetInstance>;

    /**
     * Class constructor.
     * @param layerId The layer's identifier.
     * @param layerIndex The layer's ordering index.
     */
    public function SLT2DBoardLayer(layerId:String, layerIndex:int) {
        super(layerId, layerIndex);
        _assetInstances = new <SLT2DAssetInstance>[];
    }

    /**
     * The asset instances of the layer.
     */
    saltr_internal function get assetInstances():Vector.<SLT2DAssetInstance> {
        return _assetInstances;
    }

    /**
     * Adds an asset instance.
     * @param instance An asset instance to add.
     */
    saltr_internal function addAssetInstance(instance:SLT2DAssetInstance):void {
        _assetInstances.push(instance);
    }
}
}
