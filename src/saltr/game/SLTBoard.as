/**
 * Created by GSAR on 7/6/14.
 */
package saltr.game {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTBoard class represents the game board.
 */
public class SLTBoard {

    /**
     * Specifies the board type for matching game.
     */
    public static const BOARD_TYPE_MATCHING:String = "matrix";

    /**
     * Specifies the board type for Canvas2D game.
     */
    public static const BOARD_TYPE_CANVAS_2D:String = "canvas2d";

    protected var _propertyObjects:Dictionary;
    protected var _layers:Dictionary;
    private var _checkpoints:Dictionary;

    /**
     * Class constructor.
     * @param layers The layers of the board.
     * @param properties The board associated properties.
     */
    public function SLTBoard(layers:Dictionary, propertyObjects:Dictionary, checkpoints:Dictionary) {
        _propertyObjects = propertyObjects;
        _layers = layers;
        _checkpoints = checkpoints;
    }

    /**
     * The board associated properties.
     */
    public function get propertyObjects():Object {
        return _propertyObjects;
    }

    /**
     * The layers of the board.
     */
    public function get layers():Dictionary {
        return _layers;
    }

    /**
     * Returns layer of board. Null if there is no layer with requested token.
     * @param token The layer token to search.
     * @return
     */
    public function getLayerByToken(token:String):SLTBoardLayer {
        for (var i:int = 0, length:int = _layers.length; i < length; i++) {
            var layer:SLTBoardLayer = _layers[i];
            if (layer.token == token) {
                return layer;
            }
        }
        return null;
    }

    /**
     * Provides the checkpoint.
     * @param token The checkpoint's token.
     */
    public function getCheckpoint(token:String):SLTCheckpoint {
        return _checkpoints[token];
    }

    /**
     * Provides the checkpoints.
     */
    public function getCheckpoints():Vector.<SLTCheckpoint> {
        var checkpointVector:Vector.<SLTCheckpoint> = new Vector.<SLTCheckpoint>();
        for each(var checkpoint:SLTCheckpoint in _checkpoints) {
            checkpointVector.push(checkpoint);
        }
        return checkpointVector;
    }

    /**
     * Regenerates the content of the board.
     */
    public function regenerate():void {
        throw new Error("Virtual function call: regenerate");
    }
}
}
