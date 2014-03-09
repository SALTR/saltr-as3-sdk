/**
 * User: sarg
 * Date: 1/12/14
 * Time: 1:39 PM
 */
package saltr.parser.gameeditor {
internal class SLTCellMatrix {
    private var _width:int;
    private var _height:int;
    private var _rawData:Vector.<SLTCell>;
    private var _iterator:SLTCellMatrixIterator;

    public function SLTCellMatrix(width:int, height:int) {
        _width = width;
        _height = height;
        allocate();
    }

    private function allocate():void {
        _rawData = new Vector.<SLTCell>(_width * _height);
    }

    public function insert(row:int, col:int, cell:SLTCell):void {
        _rawData[ (col * _width) + row ] = cell;
    }

    public function retrieve(row:int, col:int):SLTCell {
        return _rawData[(col * _width) + row];
    }

    public function get width():int {
        return _width;
    }

    public function get height():int {
        return _height;
    }

    public function get iterator():SLTCellMatrixIterator {
        if (!_iterator) {
            _iterator = new SLTCellMatrixIterator(this);
        }
        return _iterator;
    }

    internal function get rawData():Vector.<SLTCell> {
        return _rawData;
    }
}
}
