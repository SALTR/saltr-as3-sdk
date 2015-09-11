package saltr.game {
import flash.utils.Dictionary;

import saltr.game.canvas2d.SLT2DLevelParser;
import saltr.game.matching.SLTMatchingLevelParser;
import saltr.status.SLTStatusLevelsParserMissing;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTLevel class represents the game's level.
 */
public class SLTLevel {
    protected var _boards:Dictionary;

    private var _globalIndex:int;
    private var _localIndex:int;
    private var _packIndex:int;
    private var _contentUrl:String;
    private var _properties:Object;
    private var _version:String;

    private var _contentReady:Boolean;
    private var _assetMap:Dictionary;

    private var _levelType:String;

    /**
     * Specifies that there is no level specified for the game.
     */
    public static const LEVEL_TYPE_NONE:String = "noLevels";

    /**
     * Specifies the level type for matching game.
     */
    public static const LEVEL_TYPE_MATCHING:String = "matrix";

    /**
     * Specifies the level type for Canvas2D game.
     */
    public static const LEVEL_TYPE_2DCANVAS:String = "2d";

    /**
     * Provides the level parser for the given level type.
     * @param levelType The type of the level.
     * @return The level type corresponding level parser.
     */
    private static function getParser(levelType:String):SLTLevelParser {
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

    /**
     * Class constructor.
     * @param globalIndex The global index of the level.
     * @param localIndex The local index of the level in the pack.
     * @param packIndex The index of the pack the level is in.
     * @param contentUrl The content URL of the level.
     * @param version The current version of the level.
     * @param levelType The type of the level.
     */
    public function SLTLevel(globalIndex:int, localIndex:int, packIndex:int, contentUrl:String, version:String, levelType:String) {
        _globalIndex = globalIndex;
        _localIndex = localIndex;
        _packIndex = packIndex;
        _contentUrl = contentUrl;
        _version = version;
        _contentReady = false;
        _levelType = levelType;
    }

    /**
     * The global index of the level.
     */
    public function get globalIndex():int {
        return _globalIndex;
    }

    /**
     * The local index of the level in the pack.
     */
    public function get localIndex():int {
        return _localIndex;
    }

    /**
     * The properties of the level.
     */
    public function get properties():Object {
        return _properties;
    }

    /**
     * The content URL of the level.
     */
    public function get contentUrl():String {
        return _contentUrl;
    }

    /**
     * The content ready state.
     */
    public function get contentReady():Boolean {
        return _contentReady;
    }

    /**
     * The current version of the level.
     */
    public function get version():String {
        return _version;
    }

    /**
     * The index of the pack the level is in.
     */
    public function get packIndex():int {
        return _packIndex;
    }

    /**
     * The boards.
     */
    public function get boards():Dictionary {
        return _boards;
    }

    /**
     * Gets the board by identifier.
     * @param id The board identifier.
     * @return The board with provided identifier.
     */
    public function getBoard(id:String):SLTBoard {
        return _boards[id];
    }

    /**
     * Updates the content of the level.
     */
    public function updateContent(rootNode:Object):void {
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
                _boards = parser.parseLevelContent(rootNode, _assetMap);
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

    /**
     * Regenerates contents of all boards.
     */
    public function regenerateAllBoards():void {
        for each (var board:SLTBoard in _boards) {
            board.regenerate();
        }
    }

    /**
     * Regenerates content of the board by identifier.
     * @param boardId The board identifier.
     */
    public function regenerateBoard(boardId:String):void {
        if (_boards != null && _boards[boardId] != null) {
            var board:SLTBoard = _boards[boardId];
            board.regenerate();
        }
    }

}
}
