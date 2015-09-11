/**
 * Created by GSAR on 7/12/14.
 */
package saltr.game.canvas2d {
import flash.geom.Point;
import flash.utils.Dictionary;

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
    private var _positions:Dictionary;

    /**
     * Class constructor.
     * @param token The unique identifier of the asset.
     * @param state The current instance state.
     * @param properties The current instance properties.
     * @param x The current instance x coordinate.
     * @param y The current instance y coordinate.
     * @param scaleX The current instance scale by X value.
     * @param scaleY The current instance scale by Y value.
     * @param rotation The current instance rotation.
     * @param positions The current instance positions.
     */
    public function SLT2DAssetInstance(token:String, state:SLTAssetState, properties:Object, x:Number, y:Number, scaleX:Number, scaleY:Number, rotation:Number, positions:Dictionary) {
        _x = x;
        _y = y;
        _scaleX = scaleX;
        _scaleY = scaleY;
        _rotation = rotation;
        _positions = positions;

        super(token, getScaleAppliedState(state), properties);
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

    /**
     * The current instance positions.
     */
    public function get positions():Dictionary {
        return _positions;
    }

    /**
     * The current instance position by id.
     */
    public function getPositionById(id:String):Point {
        return _positions[id];
    }

    private function getScaleAppliedState(state:SLTAssetState):SLTAssetState {
        var clonedState:SLT2DAssetState = (state as SLT2DAssetState).clone();
        clonedState.setWidth(clonedState.width * _scaleX);
        clonedState.setHeight(clonedState.height * _scaleY);
        return clonedState;
    }
}
}
