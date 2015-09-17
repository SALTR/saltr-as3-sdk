/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import flash.utils.Dictionary;

import saltr.game.canvas2d.SLT2DBoardParser;
import saltr.game.matching.SLTMatchingBoardParser;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTLevelParser class represents the level parser.
 * @private
 */
public class SLTLevelParser {

    /**
     * Specifies the board type for matching game.
     */
    saltr_internal static const BOARD_TYPE_MATCHING:String = "matrix";

    /**
     * Specifies the board type for Canvas2D game.
     */
    saltr_internal static const BOARD_TYPE_CANVAS_2D:String = "canvas2d";

    saltr_internal static const NODE_PROPERTY_OBJECTS:String = "propertyObjects";
    private static const NODE_PROPERTY_LEVEL:String = "level";

    private static var INSTANCE:SLTLevelParser;

    private var _matchingBoardParser:SLTMatchingBoardParser;
    private var _canvas2dBoardParser:SLT2DBoardParser;

    /**
     * Returns an instance of SLTLevelParser class.
     */
    saltr_internal static function getInstance():SLTLevelParser {
        if (!INSTANCE) {
            INSTANCE = new SLTLevelParser(new Singleton());
        }
        return INSTANCE;
    }

    /**
     * Class constructor.
     */
    public function SLTLevelParser(singleton:Singleton) {
        if (singleton == null) {
            throw new Error("Class cannot be instantiated. Please use the method called getInstance.");
        }
        _matchingBoardParser = new SLTMatchingBoardParser();
        _canvas2dBoardParser = new SLT2DBoardParser();
    }

    saltr_internal final function parseLevelProperties(rootNode:Object):Dictionary {
        if (rootNode.hasOwnProperty(NODE_PROPERTY_OBJECTS) &&
                rootNode[NODE_PROPERTY_OBJECTS].hasOwnProperty(NODE_PROPERTY_LEVEL)) {
            var properties:Dictionary = new Dictionary();
            var levelPropertyNodes:Array = rootNode[NODE_PROPERTY_OBJECTS][NODE_PROPERTY_LEVEL];
            for (var i:int = 0, len:int = levelPropertyNodes.length; i < len; ++i) {
                var levelPropertyNode:Object = levelPropertyNodes[i];
                properties[levelPropertyNode.token] = levelPropertyNode.properties;
            }
            return properties;
        }
        return null;
    }

    /**
     * Parses the board content.
     * @param rootNode The root node.
     * @param assetMap The asset map.
     * @param boardType The board type.
     * @return The parsed boards.
     */
    saltr_internal function parseBoardContent(rootNode:Object, assetMap:Dictionary, boardType:String):Dictionary {
        var boardParser:SLTBoardParser = getBoardParser(boardType);
        return boardParser.parseBoardContent(rootNode, assetMap);
    }

    /**
     * Parses the level assets.
     * @return The parsed assets.
     */
    saltr_internal function parseAssets(rootNode:Object, boardType:String):Dictionary {
        var assetNodes:Object = rootNode["assets"][boardType];
        var assetMap:Dictionary = new Dictionary();
        for (var assetId:Object in assetNodes) {
            assetMap[assetId] = parseAsset(assetNodes[assetId], boardType);
        }
        return assetMap;
    }

    //Parsing assets here
    private function parseAsset(assetNode:Object, boardType:String):SLTAsset {
        var token:String;
        var statesMap:Dictionary;
        var properties:Object = null;

        if (assetNode.hasOwnProperty("token")) {
            token = assetNode.token;
        }

        if (assetNode.hasOwnProperty("states")) {
            statesMap = parseAssetStates(assetNode.states, boardType);
        }

        if (assetNode.hasOwnProperty("properties")) {
            properties = assetNode.properties;
        }

        return new SLTAsset(token, statesMap, properties);
    }

    private function parseAssetStates(stateNodes:Object, boardType:String):Dictionary {
        var statesMap:Dictionary = new Dictionary();
        for (var stateId:Object in stateNodes) {
            statesMap[stateId] = parseAssetState(stateNodes[stateId], boardType);
        }
        return statesMap;
    }

    private final function parseAssetState(stateNode:Object, boardType:String):SLTAssetState {
        var boardParser:SLTBoardParser = getBoardParser(boardType);
        return boardParser.parseAssetState(stateNode);
    }

    private final function getBoardParser(boardType:String):SLTBoardParser {
        if (BOARD_TYPE_MATCHING == boardType) {
            return _matchingBoardParser;
        } else if (BOARD_TYPE_CANVAS_2D == boardType) {
            return _canvas2dBoardParser;
        } else {
            throw new Error("Board parser missing error");
        }
    }
}
}

class Singleton {
}