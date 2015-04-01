/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {

/**
 * The SLTCells class provides convenient access to board cells.
 */
public class SLTCells {
    private var _width:int;
    private var _height:int;
    private var _rawData:Vector.<SLTCell>;
    private var _iterator:SLTCellsIterator;

    /**
     * Class constructor.
     * @param width The number of columns.
     * @param height The number of rows.
     */
    public function SLTCells(width:int, height:int) {
        _width = width;
        _height = height;
        allocate();
    }

    private function allocate():void {
        _rawData = new Vector.<SLTCell>(_width * _height);
    }

    /**
     * Inserts cell at given column and row.
     * @param col The column.
     * @param row The row.
     * @param cell The cell.
     */
    public function insert(col:int, row:int, cell:SLTCell):void {
        _rawData[ (row * _width) + col] = cell;
    }

    /**
     * Retrieves the cell specified by column and row.
     * @param col The column.
     * @param row The row.
     * @return The cell at given col and row.
     */
    public function retrieve(col:int, row:int):SLTCell {
        var retVal:SLTCell = null;
        if(col < _width && row < _height) {
            retVal = _rawData[(row * _width) + col];
        }
        return retVal;
    }

    /**
     * The number of columns.
     */
    public function get width():int {
        return _width;
    }

    /**
     * The number of rows.
     */
    public function get height():int {
        return _height;
    }

    /**
     * The cells iterator.
     */
    public function get iterator():SLTCellsIterator {
        if (!_iterator) {
            _iterator = new SLTCellsIterator(this);
        }
        return _iterator;
    }

    internal function get rawData():Vector.<SLTCell> {
        return _rawData;
    }
}
}
