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

    protected var _properties:Object;
    protected var _layers:Vector.<SLTBoardLayer>;
    private var _checkpoints:Dictionary;

    /**
     * Class constructor.
     * @param layers The layers of the board.
     * @param properties The board associated properties.
     */
    public function SLTBoard(layers:Vector.<SLTBoardLayer>, properties:Object, checkpoints:Dictionary) {
        _properties = properties;
        _layers = layers;
        _checkpoints = checkpoints;
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
