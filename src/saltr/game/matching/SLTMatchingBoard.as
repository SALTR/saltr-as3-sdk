/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
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
     * @param properties The board associated properties.
     */
    public function SLTMatchingBoard(config:SLTMatchingBoardConfig, properties:Object) {
        super(config.layers, properties);
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
        for (var i:int = 0, len:int = _layers.length; i < len; ++i) {
            var layer:SLTMatchingBoardLayer = _config.layers[i] as SLTMatchingBoardLayer;
            var generator:SLTMatchingBoardGeneratorBase = SLTMatchingBoardGeneratorBase.getGenerator(layer);
            generator.generate(_config, layer);
        }
    }
}
}
