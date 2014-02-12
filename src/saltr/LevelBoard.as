/**
 * User: hrut
 * Date: 2/11/14
 * Time: 3:01 PM
 */
package saltr {
import flash.utils.Dictionary;

import saltr.parser.LevelParser;
import saltr.parser.data.Vector2D;
import saltr.parser.gameeditor.BoardData;

public class LevelBoard {
    public static var MAIN_BOARD_ID:String = "main";

    private var _rows:int;
    private var _cols:int;
    private var _blockedCells:Array;
    private var _position:Array;
    private var _boardVector:Vector2D;
    private var _rawBoard:Object;
    private var _boardData:BoardData;

    public function LevelBoard(rawBoard:Object, boardData:BoardData) {
        _rawBoard = rawBoard;
        _boardData = boardData;
        _cols = _rawBoard.cols;
        _rows = _rawBoard.rows;
        _blockedCells = _rawBoard.blockedCells;
        _position = _rawBoard.position;

        _boardVector = new Vector2D(_cols, _rows);
        LevelParser.parseBoard(_boardVector, _rawBoard, _boardData);
    }

    public function regenerateChunks():void {
        LevelParser.regenerateChunks(_boardVector, _rawBoard, _boardData);
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

    public function get blockedCells():Array {
        return _blockedCells;
    }

    public function get position():Array {
        return _position;
    }

    public function get properties():Dictionary {
        return _rawBoard.properties;
    }

    public function get boardVector():Vector2D {
        return _boardVector;
    }

    public function get boardData():BoardData {
        return _boardData;
    }
}
}
