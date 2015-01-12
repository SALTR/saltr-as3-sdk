/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTBoard;
import saltr.game.SLTBoardLayer;

/**
 * The SLT2DBoard class represents the 2D game board.
 */
public class SLT2DBoard extends SLTBoard {

    private var _width:Number;
    private var _height:Number;

    /**
     * Class constructor.
     * @param width - The width of the board in pixels as is in Saltr level editor.
     * @param height - The height of the board in pixels as is in Saltr level editor.
     * @param layers - The layers of the board.
     * @param properties - The board associated properties.
     */
    public function SLT2DBoard(width:Number, height:Number, layers:Vector.<SLTBoardLayer>, properties:Object) {
        super(layers, properties);
        _width = width;
        _height = height;
    }

    /**
     * The width of the board in pixels as is in Saltr level editor.
     */
    public function get width():Number {
        return _width;
    }

    /**
     * The height of the board in pixels as is in Saltr level editor.
     */
    public function get height():Number {
        return _height;
    }
}
}
