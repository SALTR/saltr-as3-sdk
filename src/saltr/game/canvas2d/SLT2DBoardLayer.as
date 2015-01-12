/**
 * Created by GSAR on 7/11/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTBoardLayer;

/**
 * The SLT2DBoardLayer class represents the game 2D board's layer.
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
    public function get assetInstances():Vector.<SLT2DAssetInstance> {
        return _assetInstances;
    }

    /**
     * Adds an asset instance.
     * @param instance An asset instance to add.
     */
    public function addAssetInstance(instance:SLT2DAssetInstance):void {
        _assetInstances.push(instance);
    }
}
}
