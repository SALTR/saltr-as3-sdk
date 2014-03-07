/**
 * User: sarg
 * Date: 1/12/14
 * Time: 1:39 PM
 */
package saltr.parser.data {
public class SLTVector2D {
    private var _width:int;
    private var _height:int;
    private var _rawData:Vector.<Object>;
    private var _iterator:SLTVector2DIterator;

    public function SLTVector2D(width:int, height:int) {
        _width = width;
        _height = height;
        allocate();
    }

    private function allocate():void {
        _rawData = new Vector.<Object>(_width * _height);
    }

    public function insert(row:int, col:int, object:Object):void {
        _rawData[ (col * _width) + row ] = object;
    }

    public function retrieve(row:int, col:int):Object {
        return _rawData[(col * _width) + row];
    }

    public function get width():int {
        return _width;
    }

    public function get height():int {
        return _height;
    }

    public function get iterator():SLTVector2DIterator {
        if (!_iterator) {
            _iterator = new SLTVector2DIterator(this);
        }
        return _iterator;
    }


    internal function get rawData():Vector.<Object> {
        return _rawData;
    }
}
}
