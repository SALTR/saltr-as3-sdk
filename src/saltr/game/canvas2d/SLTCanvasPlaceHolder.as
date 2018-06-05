/**
 * Created by daal on 1/14/16.
 */
package saltr.game.canvas2d {
import saltr.game.SLTAssetPlaceHolder;

public class SLTCanvasPlaceHolder extends SLTAssetPlaceHolder {

    private var _x:Number;
    private var _y:Number;

    public function SLTCanvasPlaceHolder(x:Number, y:Number, tags:Array) {
        super(tags);
        _x = x;
        _y = y;
    }

    public function get x():Number {
        return _x;
    }

    public function get y():Number {
        return _y;
    }
}
}
