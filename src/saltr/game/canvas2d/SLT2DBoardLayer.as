/**
 * Created by GSAR on 7/11/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTBoardLayer;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLT2DBoardLayer class represents the game 2D board's layer.
 */
public class SLT2DBoardLayer extends SLTBoardLayer {

    private var _assets:Array;

    /**
     * Class constructor.
     * @param layerId The layer's identifier.
     * @param layerIndex The layer's ordering index.
     */
    public function SLT2DBoardLayer(layerId:String, layerIndex:int, assets : Array) {
        super(layerId, layerIndex);
        _assets = assets;
    }

    public function get assets():Array {
        return _assets;
    }
}
}
