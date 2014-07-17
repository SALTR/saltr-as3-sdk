package saltr.game {
import flash.utils.Dictionary;

import plexonic.error.PureVirtualFunctionError;

public class SLTLevel {
    protected var _boards:Dictionary;

    private var _id:String;
    private var _contentUrl:String;
    private var _index:int;
    private var _properties:Object;
    private var _contentReady:Boolean;
    private var _version:String;
    private var _packIndex:int;
    private var _localIndex:int;
    private var _assetMap:Dictionary;

    public static const LEVEL_TYPE_NONE:String = "noLevels";
    public static const LEVEL_TYPE_MATCHING:String = "matching";
    public static const LEVEL_TYPE_2DCANVAS:String = "canvas2D";

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

    public function updateContent(rootNode:Object):void {
        var boardsNode:Object;
        if (rootNode.hasOwnProperty("boards")) {
            boardsNode = rootNode["boards"];
        } else {
            throw new Error("[SALTR: ERROR] Level content's 'boards' node can not be found.");
        }

        var parser:SLTLevelParser = getParser();

        _properties = rootNode["properties"];

        try {
            _assetMap = parser.parseLevelAssets(rootNode);
        }
        catch (e:Error) {
            throw new Error("[SALTR: ERROR] Level content asset parsing failed.")
        }

        try {
            _boards = parser.parseLevelContent(boardsNode, _assetMap);
        }
        catch (e:Error) {
            throw new Error("[SALTR: ERROR] Level content boards parsing failed.")
        }

        regenerateAllBoards();
        _contentReady = true;
    }

    public function regenerateAllBoards():void {
        for each (var board:SLTBoard in _boards) {
            board.regenerate();
        }
    }

    public function regenerateBoard(boardId:String):void {
        if (_boards != null && _boards[boardId] != null) {
            var board:SLTBoard = _boards[boardId];
            board.regenerate();
        }
    }

    protected function getParser():SLTLevelParser {
        throw new PureVirtualFunctionError();
    }
}
}
