/**
 * Created by GSAR on 7/6/14.
 */
package saltr.game {

/**
 * The SLTBoardLayer class represents the game board's layer.
 */
public class SLTBoardLayer {

    private var _token:String;
    private var _index:int;

    /**
     * Class constructor.
     * @param token - The unique identifier of the layer.
     * @param layerIndex - The layer's ordering index.
     */
    public function SLTBoardLayer(token:String, layerIndex:int) {
        _token = token;
        _index = layerIndex;
    }

    /**
     * The unique identifier of the layer.
     */
    public function get token():String {
        return _token;
    }

    /**
     * The layer's ordering index.
     */
    public function get index():int {
        return _index;
    }

    /**
     * Regenerates the content of the layer.
     */
    public function regenerate():void {
        //override
    }
}
}
