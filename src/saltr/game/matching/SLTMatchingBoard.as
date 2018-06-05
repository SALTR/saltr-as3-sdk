/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTBoard;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTMatchingBoard class represents the matching game board.
 */
public class SLTMatchingBoard extends SLTBoard {
    private var _config:SLTMatchingBoardConfig;

    /**
     * Class constructor.
     * @param config The board configuration.
     * @param propertyObjects The board associated properties.
     * @param checkpoints The board checkpoints.
     */
    public function SLTMatchingBoard(token:String, config:SLTMatchingBoardConfig, propertyObjects:Dictionary, checkpoints:Dictionary) {
        super(token, config.layers, propertyObjects, checkpoints);
        _config = config;
    }

    /**
     * The cells of the board.
     */
    public function get cells():SLTCells {
        return _config.cells;
    }

    /**
     * The number of rows.
     */
    public function get rows():int {
        return _config.rows;
    }

    /**
     * The number of columns.
     */
    public function get cols():int {
        return _config.cols;
    }

    override public function regenerate():void {
        for (var layerToken:String in _config.layers) {
            var layer:SLTMatchingBoardLayer = _config.layers[layerToken] as SLTMatchingBoardLayer;
            var generator:SLTMatchingBoardGeneratorBase = SLTMatchingBoardGeneratorBase.getGenerator(_config, layer);
            generator.generate(_config, layer);
        }
    }
}
}
