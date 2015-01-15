/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTBoard;
import saltr.game.SLTBoardLayer;

/**
 * The SLTMatchingBoard class represents the matching game board.
 */
public class SLTMatchingBoard extends SLTBoard {
    private var _cells:SLTCells;
    private var _rows:int;
    private var _cols:int;

    /**
     * Class constructor.
     * @param cells The cells of the board.
     * @param layers The layers of the board.
     * @param properties The board associated properties.
     */
    public function SLTMatchingBoard(cells:SLTCells, layers:Vector.<SLTBoardLayer>, properties:Object) {
        super(layers, properties);
        _cells = cells;
        _cols = cells.width;
        _rows = cells.height;
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
}
}
