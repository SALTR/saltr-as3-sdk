/**
 * User: hrut
 * Date: 2/11/14
 * Time: 3:01 PM
 */
package saltr {
import flash.utils.Dictionary;

import saltr.parser.SLTLevelParser;
import saltr.parser.data.SLTVector2D;
import saltr.parser.gameeditor.SLTBoardData;

public class SLTLevelBoard {
    public static var MAIN_BOARD_ID:String = "main";

    private var _rows:int;
    private var _cols:int;
    private var _position:Array;
    private var _boardVector:SLTVector2D;
    private var _rawBoard:Object;
    private var _boardData:SLTBoardData;

    public function SLTLevelBoard(rawBoard:Object, boardData:SLTBoardData) {
        _rawBoard = rawBoard;
        _boardData = boardData;
        _cols = _rawBoard.cols;
        _rows = _rawBoard.rows;
        _position = _rawBoard.position;

        _boardVector = new SLTVector2D(_cols, _rows);
        SLTLevelParser.parseBoard(_boardVector, _rawBoard, _boardData);
    }

    public function regenerateChunks():void {
        SLTLevelParser.regenerateChunks(_boardVector, _rawBoard, _boardData);
    }

    public function get composites():Dictionary {
        return _rawBoard.composites;
    }

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
        if(_rawBoard.hasOwnProperty("properties") && _rawBoard.properties.hasOwnProperty("board")) {
            return _rawBoard.properties.board;
        }
        return {};

    }

    public function get boardVector():SLTVector2D {
        return _boardVector;
    }

    public function get boardData():SLTBoardData {
        return _boardData;
    }
}
}
