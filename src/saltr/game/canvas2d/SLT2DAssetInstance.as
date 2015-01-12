/**
 * Created by GSAR on 7/12/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTAssetInstance;
import saltr.game.SLTAssetState;

/**
 * The SLT2DAssetInstance class represents the game 2D asset instance placed on board.
 */
public class SLT2DAssetInstance extends SLTAssetInstance {

    private var _x:Number;
    private var _y:Number;
    private var _rotation:Number;

    /**
     * Class constructor.
     * @param token - The unique identifier of the asset.
     * @param states - The current instance states.
     * @param properties - The current instance properties.
     * @param x - The current instance x coordinate.
     * @param y - The current instance y coordinate.
     * @param rotation - The current instance rotation.
     */
    public function SLT2DAssetInstance(token:String, states:Vector.<SLTAssetState>, properties:Object, x:Number, y:Number, rotation:Number) {
        super(token, states, properties);

        _x = x;
        _y = y;
        _rotation = rotation;
    }

    /**
     * The current instance x coordinate.
     */
    public function get x():Number {
        return _x;
    }

    /**
     * The current instance y coordinate.
     */
    public function get y():Number {
        return _y;
    }

    /**
     * The current instance rotation.
     */
    public function get rotation():Number {
        return _rotation;
    }
}
}
