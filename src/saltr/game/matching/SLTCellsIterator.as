/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {

/**
 * The SLTCellsIterator class represents an iterator for SLTCells class.
 * @see saltr.game.matching.SLTCells
 */
public class SLTCellsIterator {
    private var _cells:SLTCells;
    private var _vectorLength:uint;
    private var _currentPosition:int;

    /**
     * Class constructor.
     * @param cells The cells to iterate on.
     */
    public function SLTCellsIterator(cells:SLTCells) {
        _cells = cells;
        reset();
    }

    /**
     * Returns <code>true</code> if the iteration has more elements.
     * @return <code>true</code> if the iteration has more elements.
     */
    public function hasNext():Boolean {
        return _currentPosition != _vectorLength;
    }

    /**
     * Return the next element in the iteration.
     * @return The next element in the iteration.
     */
    public function next():SLTCell {
        return _cells.rawData[_currentPosition++];
    }

    /**
     * Resets iterator to first element.
     */
    public function reset():void {
        _vectorLength = _cells.rawData.length;
        _currentPosition = 0;
    }

}
}
