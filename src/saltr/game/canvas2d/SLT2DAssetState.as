/**
 * Created by GSAR on 7/11/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTAssetState;

public class SLT2DAssetState extends SLTAssetState {

    private var _pivotX:Number;
    private var _pivotY:Number;

    public function SLT2DAssetState(token:String, properties:Object, pivotX:Number, pivotY:Number) {
        super(token, properties);

        _pivotX = pivotX;
        _pivotY = pivotY;
    }

    public function get pivotX():Number {
        return _pivotX;
    }

    public function get pivotY():Number {
        return _pivotY;
    }
}
}
