/**
 * Created by GSAR on 7/11/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTAssetState;

/**
 * The SLT2DAssetState class represents the 2D asset state and provides the state related properties.
 */
public class SLT2DAssetState extends SLTAssetState {

    private var _pivotX:Number;
    private var _pivotY:Number;

    /**
     * Class constructor.
     * @param token - The unique identifier of the state.
     * @param properties - The current state related properties.
     * @param pivotX - The X coordinate of the pivot relative to the top left corner, in pixels.
     * @param pivotY - The Y coordinate of the pivot relative to the top left corner, in pixels.
     */
    public function SLT2DAssetState(token:String, properties:Object, pivotX:Number, pivotY:Number) {
        super(token, properties);

        _pivotX = pivotX;
        _pivotY = pivotY;
    }

    /**
     * The X coordinate of the pivot relative to the top left corner, in pixels.
     */
    public function get pivotX():Number {
        return _pivotX;
    }

    /**
     * The Y coordinate of the pivot relative to the top left corner, in pixels.
     */
    public function get pivotY():Number {
        return _pivotY;
    }
}
}
