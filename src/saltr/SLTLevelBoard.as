/**
 * User: hrut
 * Date: 2/11/14
 * Time: 3:01 PM
 */
package saltr {
import flash.utils.Dictionary;

import saltr.parser.SLTLevelBoardParser;
import saltr.parser.data.SLTVector2D;
import saltr.parser.gameeditor.SLTLevelSettings;

public class SLTLevelBoard {
    public static var MAIN_BOARD_ID:String = "main";

    private var _rows:int;
    private var _cols:int;
    private var _position:Array;
    private var _boardVector:SLTVector2D;
    private var _rawBoard:Object;
    private var _boardProperties : Object;

    //TODO:: @daal rename boardVector to something else.
    public function SLTLevelBoard(rawBoard:Object, boardVector : SLTVector2D) {
        _rawBoard = rawBoard;
        _cols = _rawBoard.cols;
        _rows = _rawBoard.rows;
        _position = _rawBoard.position;

        _boardVector = boardVector;

        _boardProperties = {};
        if(_rawBoard.hasOwnProperty("properties") && _rawBoard.properties.hasOwnProperty("board")) {
            _boardProperties = _rawBoard.properties.board;
        }
    }

    //TODO:: @daal. Do we need this getter?
    public function get composites():Dictionary {
        return _rawBoard.composites;
    }

    //TODO:: @daal. Do we need this getter?
    public function get chunks():Dictionary {
        return _rawBoard.chunks;
    }

    public function get rows():int {
        return _rows;
    }

    public function get cols():int {
        return _cols;
    }

    public function get position():Array {
        return _position;
    }

    public function get boardProperties():Object {
        return _boardProperties;
    }

    public function get boardVector():SLTVector2D {
        return _boardVector;
    }
}
}
