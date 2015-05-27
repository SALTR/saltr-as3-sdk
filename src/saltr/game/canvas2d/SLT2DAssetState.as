/**
 * Created by GSAR on 7/11/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTAssetState;
import saltr.saltr_internal;
import saltr.utils.Utils;

use namespace saltr_internal;

/**
 * The SLT2DAssetState class represents the 2D asset state and provides the state related properties.
 */
public class SLT2DAssetState extends SLTAssetState {

    private var _pivotX:Number;
    private var _pivotY:Number;
    private var _width:Number;
    private var _height:Number;

    /**
     * Class constructor.
     * @param token The unique identifier of the state.
     * @param properties The current state related properties.
     * @param pivotX The X coordinate of the pivot relative to the top left corner, in pixels.
     * @param pivotY The Y coordinate of the pivot relative to the top left corner, in pixels.
     * @param width The width.
     * @param height The height.
     */
    public function SLT2DAssetState(token:String, properties:Object, pivotX:Number, pivotY:Number, width:Number, height:Number) {
        super(token, properties);
        _pivotX = pivotX;
        _pivotY = pivotY;
        _width = width;
        _height = height;
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

    /**
     * The Width.
     */
    public function get width():Number {
        return _width;
    }

    /**
     * The Height.
     */
    public function get height():Number {
        return _height;
    }

    /**
     * @private
     */
    saltr_internal function set width(value:Number) {
        _width = value;
    }

    /**
     * @private
     */
    saltr_internal function set height(value:Number) {
        _height = value;
    }

    /**
     * @private
     */
    saltr_internal function clone():SLT2DAssetState {
        return new SLT2DAssetState(token, Utils.cloneObject(properties), pivotX, pivotY, width, height);
    }
}
}
