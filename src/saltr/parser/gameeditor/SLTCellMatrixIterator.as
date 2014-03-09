/**
 * User: sarg
 * Date: 1/12/14
 * Time: 4:25 PM
 */
package saltr.parser.gameeditor {
internal class SLTCellMatrixIterator {
    private var _cells:SLTCellMatrix;
    private var _vectorLength:uint;
    private var _currentPosition:int;

    public function SLTCellMatrixIterator(cells:SLTCellMatrix) {
        _cells = cells;
        reset();
    }

    public function hasNext():Boolean {
        return _currentPosition != _vectorLength;
    }

    public function next():Object {
        return _cells.rawData[_currentPosition++];
    }

    public function reset():void {
        _vectorLength = _cells.rawData.length;
        _currentPosition = 0;
    }

}
}
