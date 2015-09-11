/**
 * Created by TIGR on 7/8/2015.
 */
package saltr.game {

/**
 * The SLTCheckpoint class represents the game board's checkpoint.
 */
public class SLTCheckpoint {
    public static const CHECKPOINT_ORIENTATION_HORIZONTAL:String = "horizontal";
    public static const CHECKPOINT_ORIENTATION_VERTICAL:String = "vertical";

    private var _token:String;
    private var _orientation:String;
    private var _position:Number;

    /**
     * Class constructor.
     * @param token The unique identifier.
     * @param orientation The orientation.
     * @param position The position
     */
    public function SLTCheckpoint(token:String, orientation:String, position:Number) {
        _token = token;
        _orientation = orientation;
        _position = position;
    }

    /**
     * The unique identifier of the checkpoint.
     */
    public function get token():String {
        return _token;
    }

    /**
     * The checkpoint's orientation
     */
    public function get orientation():String {
        return _orientation;
    }

    /**
     * The checkpoint's position.
     */
    public function get position():Number {
        return _position;
    }
}
}
