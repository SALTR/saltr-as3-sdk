/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTBoard;
import saltr.game.SLTBoardLayer;

public class SLTMatchingBoard extends SLTBoard {
    private var _cells:SLTCells;
    private var _rows:int;
    private var _cols:int;

    public function SLTMatchingBoard(cells:SLTCells, layers:Vector.<SLTBoardLayer>, properties:Object) {
        super(layers, properties);
        _cells = cells;
        _cols = cells.width;
        _rows = cells.height;
    }

    public function get cells():SLTCells {
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
            var layer:SLTMatchingBoardLayer = _layers[i] as SLTMatchingBoardLayer;
            layer.regenerateChunks();
        }
    }
}
}
