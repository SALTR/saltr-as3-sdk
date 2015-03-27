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
    private var _cells:SLTCells;
    private var _rows:int;
    private var _cols:int;

    private var _config:SLTMatchingBoardConfig;

    /**
     * Class constructor.
     * @param cells The cells of the board.
     * @param layers The layers of the board.
     * @param properties The board associated properties.
     */
    public function SLTMatchingBoard(config:SLTMatchingBoardConfig, properties:Object) {
        super(layers, properties);

        _config = config;
        _cells = _config.cells;
        _cols = cells.width;
        _rows = cells.height;
    }

    public function get config():SLTMatchingBoardConfig {
        return _config;
    }

    public function set config(value:*):void {
        _config = value;
    }

    /**
     * The cells of the board.
     */
    public function get cells():SLTCells {
        return _cells;
    }

    /**
     * The number of rows.
     */
    public function get rows():int {
        return _rows;
    }

    /**
     * The number of columns.
     */
    public function get cols():int {
        return _cols;
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
