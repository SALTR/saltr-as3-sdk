/**
 * Created by GSAR on 7/12/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTAssetInstance;
import saltr.game.SLTAssetState;

public class SLT2DAssetInstance extends SLTAssetInstance {

    private var _x:Number;
    private var _y:Number;
    private var _rotation:Number;

    public function SLT2DAssetInstance(token:String, states:Vector.<SLTAssetState>, properties:Object, x:Number, y:Number, rotation:Number) {
        super(token, states, properties);

        _x = x;
        _y = y;
        _rotation = rotation;
    }

    public function get x():Number {
        return _x;
    }

    public function get y():Number {
        return _y;
    }

    public function get rotation():Number {
        return _rotation;
    }
}
}
