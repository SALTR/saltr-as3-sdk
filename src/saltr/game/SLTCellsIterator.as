/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
public class SLTCellsIterator {
    private var _cells:SLTCells;
    private var _vectorLength:uint;
    private var _currentPosition:int;

    public function SLTCellsIterator(cells:SLTCells) {
        _cells = cells;
        reset();
    }

    public function hasNext():Boolean {
        return _currentPosition != _vectorLength;
    }

    public function next():SLTCell {
        return _cells.rawData[_currentPosition++];
    }

    public function reset():void {
        _vectorLength = _cells.rawData.length;
        _currentPosition = 0;
    }

}
}
