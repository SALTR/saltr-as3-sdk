/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTBoard;
import saltr.game.SLTBoardLayer;

public class SLT2DBoard extends SLTBoard {

    private var _width:Number;
    private var _height:Number;


    public function SLT2DBoard(width:Number, height:Number, layers:Vector.<SLTBoardLayer>, properties:Object) {
        super(layers, properties);
        _width = width;
        _height = height;
    }

    public function get width():Number {
        return _width;
    }

    public function get height():Number {
        return _height;
    }
}
}
