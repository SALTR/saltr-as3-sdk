/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
import flash.utils.Dictionary;

public class SLTMatchBoard extends SLTBoard {
    private var _rows:int;
    private var _cols:int;
    private var _cells:SLTCellMatrix;

    public function SLTMatchBoard(cells:SLTCellMatrix, layers:Dictionary, properties:Object) {
        super(layers, properties);
        _cells = cells;
        _cols = cells.width;
        _rows = cells.height;
    }

    public function get rows():int {
        return _rows;
    }

    public function get cols():int {
        return _cols;
    }

    public function get cells():SLTCellMatrix {
        return _cells;
    }

}
}
