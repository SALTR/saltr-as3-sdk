/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {

public class SLTCells {
    private var _width:int;
    private var _height:int;
    private var _rawData:Vector.<SLTCell>;
    private var _iterator:SLTCellsIterator;

    public function SLTCells(width:int, height:int) {
        _width = width;
        _height = height;
        allocate();
    }

    private function allocate():void {
        _rawData = new Vector.<SLTCell>(_width * _height);
    }

    public function insert(col:int, row:int, cell:SLTCell):void {
        _rawData[ (row * _width) + col] = cell;
    }

    public function retrieve(col:int, row:int):SLTCell {
        return _rawData[(row * _width) + col];
    }

    public function get width():int {
        return _width;
    }

    public function get height():int {
        return _height;
    }

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
