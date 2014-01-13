/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 10/23/12
 * Time: 4:35 PM
 */
package saltr {
import saltr.parser.LevelParser;
import saltr.parser.data.Vector2D;
import saltr.parser.gameeditor.BoardData;

public class LevelStructure {
    private var _id:String;
    private var _dataUrl:String;
    private var _index:int;
    private var _properties:Object;
    private var _cols:int;
    private var _rows:int;
    private var _board:Vector2D;
    private var _appendingRows:int;
    private var _appendingCols:int;
    private var _appendedBoard:Vector2D;
    private var _dataFetched:Boolean;
    private var _keyset:Object;
    private var _version:String;
    private var _boardData:BoardData;
    private var _data:Object;
    private var _innerProperties:Object;
    private var _rawMainBoard:Object;
    private var _rawAppendedBoard:Object;

    public function LevelStructure(id:String, index:int, dataUrl:String, properties:Object, version:String) {
        _id = id;
        _index = index;
        _dataUrl = dataUrl;
        _dataFetched = false;
        _properties = properties;
        _version = version;
    }

    public function parseData(data:Object):void {
        _data = data;
        _innerProperties = _data["properties"];
        _boardData = LevelParser.parseBoardData(data);
        _keyset = _boardData.keyset;
        _rawMainBoard = data["boards"]["main"];
        _rawAppendedBoard = data["boards"]["appended"];
        _cols = int(_rawMainBoard.cols);
        _rows = int(_rawMainBoard.rows);
        _board = new Vector2D(_cols, _rows);
        LevelParser.parseBoard(_board, _rawMainBoard, _boardData);
        if (_rawAppendedBoard) {
            _appendingRows = _rawAppendedBoard.rows ? int(_rawAppendedBoard.rows) : 1;
            _appendingCols = int(_rawAppendedBoard.cols);
            _appendedBoard = new Vector2D(_appendingCols, _appendingRows);
            LevelParser.parseBoard(_appendedBoard, _rawAppendedBoard, _boardData);
        }
        _dataFetched = true;
    }

    public function regenerateChunks():void {
        LevelParser.regenerateChunks(_board, _rawMainBoard, _boardData);
        if (_rawAppendedBoard) {
            LevelParser.regenerateChunks(_appendedBoard, _rawAppendedBoard, _boardData);
        }
    }


    public function get id():String {
        return _id;
    }

    public function get index():int {
        return _index;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get board():Vector2D {
        return _board;
    }

    public function get appendingRows():int {
        return _appendingRows;
    }

    public function get appendingCols():int {
        return _appendingCols;
    }

    public function get appendedBoard():Vector2D {
        return _appendedBoard;
    }

    public function get keyset():Object {
        return _keyset;
    }

    public function get dataUrl():String {
        return _dataUrl;
    }

    public function get dataFetched():Boolean {
        return _dataFetched;
    }

    public function get version():String {
        return _version;
    }

    public function set properties(value:Object):void {
        _properties = value;
    }

    public function get innerProperties():Object {
        return _innerProperties;
    }
}
}
