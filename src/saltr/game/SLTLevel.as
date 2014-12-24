package saltr.game {
import flash.utils.Dictionary;

import saltr.game.canvas2d.SLT2DLevelParser;
import saltr.game.matching.SLTMatchingLevelParser;
import saltr.status.SLTStatusLevelsParserMissing;

public class SLTLevel {
    protected var _boards:Dictionary;

    private var _id:String;
    private var _variationId:String;
    private var _levelType:String;
    private var _index:int;
    private var _localIndex:int;
    private var _packIndex:int;
    private var _contentUrl:String;
    private var _properties:Object;
    private var _version:String;

    private var _contentReady:Boolean;
    private var _assetMap:Dictionary;

    public static const LEVEL_TYPE_NONE:String = "noLevels";
    public static const LEVEL_TYPE_MATCHING:String = "matching";
    public static const LEVEL_TYPE_2DCANVAS:String = "canvas2D";

    public static function getParser(levelType:String):SLTLevelParser {
        switch (levelType) {
            case LEVEL_TYPE_MATCHING:
                return SLTMatchingLevelParser.getInstance();
                break;
            case LEVEL_TYPE_2DCANVAS:
                return SLT2DLevelParser.getInstance();
                break;
        }
        return null;
    }

    public function SLTLevel(id:String, variationId:String, levelType:String, index:int, localIndex:int, packIndex:int, contentUrl:String, properties:Object, version:String) {
        _id = id;
        _variationId = variationId;
        _levelType = levelType;
        _index = index;
        _localIndex = localIndex;
        _packIndex = packIndex;
        _contentUrl = contentUrl;
        _properties = properties;
        _version = version;
        _contentReady = false;
    }

    public function get variationId():String {
        return _variationId;
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

    public function getBoard(id:String):SLTBoard {
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

        var parser:SLTLevelParser = getParser(_levelType);
        if (parser != null) {
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

            if (_boards != null) {
                regenerateAllBoards();
                _contentReady = true;
            }
        } else {
            // no parser was found for current level type
            new SLTStatusLevelsParserMissing();
        }

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

}
}
