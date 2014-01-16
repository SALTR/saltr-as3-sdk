/**
 * User: sarg
 * Date: 1/12/14
 * Time: 4:25 PM
 */
package saltr.parser.data {
public class Vector2DIterator {
    private var _vector2D:Vector2D;
    private var _vectorLength:uint;
    private var _currentPosition:int;

    public function Vector2DIterator(vector2D:Vector2D) {
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
