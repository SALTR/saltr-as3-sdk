/**
 * Created by GSAR on 7/6/14.
 */
package saltr.game {
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTBoard class represents the game board.
 */
public class SLTBoard {

    protected var _properties:Object;
    protected var _layers:Vector.<SLTBoardLayer>;

    /**
     * Class constructor.
     * @param layers The layers of the board.
     * @param properties The board associated properties.
     */
    public function SLTBoard(layers:Vector.<SLTBoardLayer>, properties:Object) {
        _properties = properties;
        _layers = layers;
    }

    /**
     * The board associated properties.
     */
    public function get properties():Object {
        return _properties;
    }

    /**
     * The layers of the board.
     */
    public function get layers():Vector.<SLTBoardLayer> {
        return _layers;
    }

    /**
     * Regenerates the content of all layers.
     */
    public function regenerate():void {
        throw new Error("Virtual function call: regenerate");
    }
}
}
