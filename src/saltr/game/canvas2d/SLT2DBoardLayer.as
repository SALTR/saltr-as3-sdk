/**
 * Created by GSAR on 7/11/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTBoardLayer;

public class SLT2DBoardLayer extends SLTBoardLayer {

    private var _assetInstances:Vector.<SLT2DAssetInstance>;

    public function SLT2DBoardLayer(layerId:String, layerIndex:int) {
        super(layerId, layerIndex);
        _assetInstances = new <SLT2DAssetInstance>[];
    }

    public function get assetInstances():Vector.<SLT2DAssetInstance> {
        return _assetInstances;
    }

    public function addAssetInstance(instance:SLT2DAssetInstance):void {
        _assetInstances.push(instance);
    }
}
}
