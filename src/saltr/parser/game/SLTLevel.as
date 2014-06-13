/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
import flash.utils.Dictionary;

public class SLTLevel {
    private var _id:String;
    private var _contentUrl:String;
    private var _index:int;
    private var _properties:Object;
    private var _boards:Dictionary;
    private var _contentReady:Boolean;
    private var _version:String;
    private var _rootNode:Object;
    private var _levelSettings:SLTLevelSettings;
    private var _boardsNode:Object;
    private var _packIndex:int;
    private var _localIndex:int;


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

    public function getBoard(id:String):SLTLevelBoard {
        return _boards[id];
    }

    public function updateContent(rootNode:Object):void {
        _rootNode = rootNode;

        if (rootNode.hasOwnProperty("boards")) {
            _boardsNode = rootNode["boards"];
        } else {
            throw new Error("Boards node is not found.");
        }

        _properties = rootNode["properties"];
        _levelSettings = SLTLevelBoardParser.parseLevelSettings(rootNode);
        generateAllBoards();
        _contentReady = true;
    }

    public function generateAllBoards():void {
        if (_boardsNode != null) {
            _boards = SLTLevelBoardParser.parseLevelBoards(_boardsNode, _levelSettings);
        }
    }

    public function generateBoard(boardId:String):void {
        if (_boardsNode != null && _boardsNode[boardId] != null) {
            _boards[boardId] = SLTLevelBoardParser.parseLevelBoard(_boardsNode[boardId], _levelSettings);
        }
    }

    internal function dispose():void {
        //TODO @GSAR: implement
    }
}
}
