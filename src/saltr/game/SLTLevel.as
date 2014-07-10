/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import saltr.parser.game.*;

import flash.utils.Dictionary;

public class SLTLevel {
    private var _id:String;
    private var _contentUrl:String;
    private var _index:int;
    private var _properties:Object;
    private var _boards:Dictionary;
    private var _contentReady:Boolean;
    private var _version:String;
    private var _packIndex:int;
    private var _localIndex:int;
    private var _assetMap:Dictionary;


    //TODO @GSAR: rename this class to SLT2DBoardLevel and move the core part into base SLTLevel.
    public function SLTLevel(id:String, index:int, localIndex:int, packIndex:int, contentUrl:String, properties:Object, version:String) {
        _id = id;
        _index = index;
        _localIndex = localIndex;
        _packIndex = packIndex;
        _contentUrl = contentUrl;
        _properties = properties;
        _version = version;
        _contentReady = false;
    }

    public function get index():int {
        return _index;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get contentUrl():String {
        return _contentUrl;
    }

    public function get contentReady():Boolean {
        return _contentReady;
    }

    public function get version():String {
        return _version;
    }

    public function get localIndex():int {
        return _localIndex;
    }

    public function get packIndex():int {
        return _packIndex;
    }

    public function getBoard(id:String):SLTMatchBoard {
        return _boards[id];
    }

    public function updateContent(rootNode:Object):void {
        var boardsNode:Object;
        if (rootNode.hasOwnProperty("boards")) {
            boardsNode = rootNode["boards"];
        } else {
            throw new Error("[SALTR: ERROR] Level content's 'boards' node can not be found.");
        }

        _properties = rootNode["properties"];

        try {
            _assetMap = SLTLevelParser.parseLevelAssets(rootNode);
        }
        catch (e:Error) {
            throw new Error("[SALTR: ERROR] Level content asset parsing failed.")
        }

        try {
            _boards = SLTLevelParser.parseLevelContent(boardsNode, _assetMap);
        }
        catch (e:Error) {
            throw new Error("[SALTR: ERROR] Level content boards parsing failed.")
        }

        regenerateAllBoards();
        _contentReady = true;
    }

    public function regenerateAllBoards():void {
        for each (var board:SLTMatchBoard in _boards) {
            board.regenerateChunks();
        }
    }

    public function regenerateBoard(boardId:String):void {
        if (_boards != null && _boards[boardId] != null) {
            var board:SLTMatchBoard = _boards[boardId];
            board.regenerateChunks();
        }
    }

    internal function dispose():void {
        //TODO @GSAR: implement
    }
}
}
