/**
 * User: sarg
 * Date: 1/12/14
 * Time: 4:25 PM
 */
package saltr.parser.data {
public class SLTVector2DIterator {
    private var _vector2D:SLTVector2D;
    private var _vectorLength:uint;
    private var _currentPosition:int;

    public function SLTVector2DIterator(vector2D:SLTVector2D) {
        _vector2D = vector2D;
        reset();
    }

    public function hasNext():Boolean {
        return _currentPosition != _vectorLength;
    }

    public function next():Object {
        return _vector2D.rawData[_currentPosition++];
    }

    public function reset():void {
        _vectorLength = _vector2D.rawData.length;
        _currentPosition = 0;
    }

}
}
