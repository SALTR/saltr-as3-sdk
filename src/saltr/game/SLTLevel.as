package saltr.game {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTLevel class represents the game's level.
 */
public class SLTLevel {
    private var _matrixBoards:Dictionary;
    private var _canvas2DBoards:Dictionary;

    private var _globalIndex:int;
    private var _localIndex:int;
    private var _packIndex:int;
    private var _contentUrl:String;
    private var _alternateContentUrl:String;
    private var _levelToken:String;
    private var _packToken:String;
    private var _properties:Dictionary;
    private var _version:String;
    private var _contentReady:Boolean;
    private var _parser:SLTLevelParser;

    /**
     * Specifies that there is no level specified for the game.
     */
    public static const LEVEL_TYPE_NONE:String = "noLevels";

    /**
     * Class constructor.
     * @param globalIndex The global index of the level.
     * @param localIndex The local index of the level in the pack.
     * @param packIndex The index of the pack the level is in.
     * @param contentUrl The content URL of the level.
     * @param levelToken The token of the level feature.
     * @param packToken The token of the pack.
     * @param version The current version of the level.
     */
    public function SLTLevel(globalIndex:int, localIndex:int, packIndex:int, contentUrl:String, levelToken:String, packToken:String, version:String) {
        _globalIndex = globalIndex;
        _localIndex = localIndex;
        _packIndex = packIndex;
        _contentUrl = contentUrl;
        _levelToken = levelToken;
        _packToken = packToken;
        _version = version;
        _contentReady = false;
        _parser = SLTLevelParser.getInstance();
    }

    public function get alternateContentUrl():String {
        return _alternateContentUrl;
    }

    public function set alternateContentUrl(value:String):void {
        _alternateContentUrl = value;
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
    public function get properties():Dictionary {
        return _properties;
    }

    /**
     * The content URL of the level.
     */
    public function get contentUrl():String {
        return _contentUrl;
    }

    /**
     * The level token.
     */
    public function get levelToken():String {
        return _levelToken;
    }

    /**
     * The pack token.
     */
    public function get packToken():String {
        return _packToken;
    }

    /**
     * The content ready state.
     */
    public function get contentReady():Boolean {
        return _contentReady;
    }

    /**
     * Updates contentReady value. For internal use only.
     * @param value
     */
    public function set contentReady(value:Boolean):void {
        _contentReady = value;
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
     * The matrix boards.
     */
    public function get matrixBoards():Dictionary {
        return _matrixBoards;
    }

    /**
     * The canvas 2D boards.
     */
    public function get canvas2DBoards():Dictionary {
        return _canvas2DBoards;
    }

    /**
     * Gets the matrix board by identifier.
     * @param token The board identifier.
     * @return The board with provided identifier.
     */
    public function getMatrixBoard(token:String):SLTBoard {
        if (null != _matrixBoards) {
            return _matrixBoards[token];
        } else {
            return null;
        }
    }

    /**
     * Gets the canvas 2D board by identifier.
     * @param token The board identifier.
     * @return The board with provided identifier.
     */
    public function getCanvas2DBoard(token:String):SLTBoard {
        if (null != _canvas2DBoards) {
            return _canvas2DBoards[token];
        } else {
            return null;
        }
    }

    public function update(version:String, contentUrl:String):void {
        _contentUrl = contentUrl;
        _version = version;
        _contentReady = false;
    }

    /**
     * Updates the content of the level.
     */
    public function updateContent(rootNode:Object):void {
        _properties = _parser.parseLevelProperties(rootNode);

        var matrixAssetMap:Dictionary;
        var canvas2DAssetMap:Dictionary;

        try {
            matrixAssetMap = _parser.parseAssets(rootNode, SLTBoard.BOARD_TYPE_MATCHING);
            canvas2DAssetMap = _parser.parseAssets(rootNode, SLTBoard.BOARD_TYPE_CANVAS_2D);
        }
        catch (e:Error) {
            throw new Error("[SALTR: ERROR] Level content asset parsing failed.")
        }

        try {
            _matrixBoards = _parser.parseBoardContent(rootNode, matrixAssetMap, SLTBoard.BOARD_TYPE_MATCHING);
            _canvas2DBoards = _parser.parseBoardContent(rootNode, canvas2DAssetMap, SLTBoard.BOARD_TYPE_CANVAS_2D);
        }
        catch (e:Error) {
            throw new Error("[SALTR: ERROR] Level content boards parsing failed.")
        }

        regenerateAllBoards();
        _contentReady = true;
    }


    /**
     * Clear the content of the level.
     */
    saltr_internal function clearContent():void {
        _properties = null;
        _matrixBoards = null;
        _canvas2DBoards = null;
        _contentReady = false;
    }

    /**
     * Regenerates contents of all boards.
     */
    public function regenerateAllBoards():void {
        if (null != _matrixBoards) {
            for (var matrixBoardToken:String in _matrixBoards) {
                regenerateBoard(SLTBoard.BOARD_TYPE_MATCHING, matrixBoardToken);
            }
        }
        if (null != _canvas2DBoards) {
            for (var canvasBoardToken:String in _canvas2DBoards) {
                regenerateBoard(SLTBoard.BOARD_TYPE_CANVAS_2D, canvasBoardToken);
            }
        }
    }

    /**
     * Regenerates content of the board by identifier.
     * @param boardType The board type.
     * @param boardToken The board token.
     */
    public function regenerateBoard(boardType:String, boardToken:String):void {
        var board:SLTBoard = getBoard(boardType, boardToken);
        if (null != board) {
            board.regenerate();
        }
    }

    public final function getBoard(boardType:String, boardToken:String):SLTBoard {
        if (boardType == SLTBoard.BOARD_TYPE_MATCHING) {
            return getMatrixBoard(boardToken);
        }
        if (boardType == SLTBoard.BOARD_TYPE_CANVAS_2D) {
            return getCanvas2DBoard(boardToken);
        }
        return null;
    }
}
}
