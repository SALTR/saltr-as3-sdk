/**
 * User: hrut
 * Date: 2/11/14
 * Time: 3:01 PM
 */
package saltr {
import flash.utils.Dictionary;

import saltr.parser.SLTLevelBoardParser;
import saltr.parser.data.SLTCellMatrix;
import saltr.parser.gameeditor.SLTLevelSettings;

public class SLTLevelBoard {
    private var _rows:int;
    private var _cols:int;
    private var _position:Array;
    private var _cells:SLTCellMatrix;
    private var _boardData:Object;
    private var _boardProperties:Object;

    public function SLTLevelBoard(boardData:Object, cells:SLTCellMatrix) {
        _boardData = boardData;
        _cols = _boardData.cols;
        _rows = _boardData.rows;
        _position = _boardData.position;

        _cells = cells;

        _boardProperties = {};
        if (_boardData.hasOwnProperty("properties") && _boardData.properties.hasOwnProperty("board")) {
            _boardProperties = _boardData.properties.board;
        }
    }

    //TODO:: @daal. Do we need this getter?
    public function get composites():Dictionary {
        return _boardData.composites;
    }

    //TODO:: @daal. Do we need this getter?
    public function get chunks():Dictionary {
        return _boardData.chunks;
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

    public function get cells():SLTCellMatrix {
        return _cells;
    }
}
}
