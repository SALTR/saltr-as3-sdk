/**
 * Created by GSAR on 7/6/14.
 */
package saltr.game {
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTBoardLayer class represents the game board's layer.
 * @private
 */
public class SLTBoardLayer {

    private var _token:String;
    private var _index:int;

    /**
     * Class constructor.
     * @param token The unique identifier of the layer.
     * @param layerIndex The layer's ordering index.
     */
    public function SLTBoardLayer(token:String, layerIndex:int) {
        _token = token;
        _index = layerIndex;
    }

    /**
     * The unique identifier of the layer.
     */
    saltr_internal function get token():String {
        return _token;
    }

    /**
     * The layer's ordering index.
     */
    saltr_internal function get index():int {
        return _index;
    }

    /**
     * Regenerates the content of the layer.
     */
    saltr_internal function regenerate():void {
        //override
    }
}
}
