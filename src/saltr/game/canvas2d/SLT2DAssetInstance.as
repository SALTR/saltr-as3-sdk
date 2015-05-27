/**
 * Created by GSAR on 7/12/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTAssetInstance;
import saltr.game.SLTAssetState;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLT2DAssetInstance class represents the game 2D asset instance placed on board.
 */
public class SLT2DAssetInstance extends SLTAssetInstance {

    private var _x:Number;
    private var _y:Number;
    private var _scaleX:Number;
    private var _scaleY:Number;
    private var _rotation:Number;

    /**
     * Class constructor.
     * @param token The unique identifier of the asset.
     * @param states The current instance states.
     * @param properties The current instance properties.
     * @param x The current instance x coordinate.
     * @param y The current instance y coordinate.
     * @param rotation The current instance rotation.
     */
    public function SLT2DAssetInstance(token:String, states:Vector.<SLTAssetState>, properties:Object, x:Number, y:Number, scaleX:Number, scaleY:Number, rotation:Number) {
        _x = x;
        _y = y;
        _scaleX = scaleX;
        _scaleY = scaleY;
        _rotation = rotation;

        super(token, getScaleAppliedStates(states), properties);
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

    private function getScaleAppliedStates(states:Vector.<SLTAssetState>):Vector.<SLTAssetState> {
        var scaleAppliedStates:Vector.<SLTAssetState> = new Vector.<SLTAssetState>();
        for (var i:int = 0; i < states.length; ++i) {
            var clonedState:SLT2DAssetState = (states[i] as SLT2DAssetState).clone();
            clonedState.width = clonedState.width * _scaleX;
            clonedState.height = clonedState.height * _scaleY;
            scaleAppliedStates.push(clonedState);
        }
        return scaleAppliedStates;
    }
}
}
