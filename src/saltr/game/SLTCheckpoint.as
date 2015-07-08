/**
 * Created by TIGR on 7/8/2015.
 */
package saltr.game {
public class SLTCheckpoint {
    public static const CHECKPOINT_ORIENTATION_HORIZONTAL:String = "horizontal";
    public static const CHECKPOINT_ORIENTATION_VERTICAL:String = "vertical";

    private var _token:String;
    private var _orientation:String;
    private var _position:Number;

    public function SLTCheckpoint(token:String, orientation:String, position:Number) {
        _token = token;
        _orientation = orientation;
        _position = position;
    }

    public function get token():String {
        return _token;
    }

    public function get orientation():String {
        return _orientation;
    }

    public function get position():Number {
        return _position;
    }
}
}
