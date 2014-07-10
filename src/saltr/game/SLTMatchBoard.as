/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {

public class SLTMatchBoard extends SLTBoard {
    private var _cells:SLTCellMatrix;
    private var _rows:int;
    private var _cols:int;

    public function SLTMatchBoard(cells:SLTCellMatrix, layers:Vector.<SLTBoardLayer>, properties:Object) {
        super(layers, properties);
        _cells = cells;
        _cols = cells.width;
        _rows = cells.height;
    }

    public function get cells():SLTCellMatrix {
        return _cells;
    }

    public function get rows():int {
        return _rows;
    }

    public function get cols():int {
        return _cols;
    }

    public function regenerateChunks():void {
        for (var i:int = 0, len:int = _layers.length; i < len; ++i) {
            var layer:SLTMatchBoardLayer = _layers[i] as SLTMatchBoardLayer;
            layer.regenerateChunks();
        }
    }
}
}
