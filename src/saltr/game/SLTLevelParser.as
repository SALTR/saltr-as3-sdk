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
    saltr_internal static const NODE_PROPERTY_OBJECTS:String = "propertyObjects";

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
        if (rootNode.hasOwnProperty(NODE_PROPERTY_OBJECTS)) {
            var properties:Dictionary = new Dictionary();
            var levelPropertyNodes:Object = rootNode[NODE_PROPERTY_OBJECTS];
            for (var token:String in levelPropertyNodes) {
                //var levelPropertyNode:Object = levelPropertyNodes[token];
                properties[token] = levelPropertyNodes[token];
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
        var assetMap:Dictionary = null;
        if (rootNode["assets"].hasOwnProperty(boardType)) {
            var assetNodes:Object = rootNode["assets"][boardType];
            assetMap = new Dictionary();
            for (var assetId:String in assetNodes) {
                assetMap[assetId] = parseAsset(assetNodes[assetId], boardType);
            }
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
        if (SLTBoard.BOARD_TYPE_MATCHING == boardType) {
            return _matchingBoardParser;
        } else if (SLTBoard.BOARD_TYPE_CANVAS_2D == boardType) {
            return _canvas2dBoardParser;
        } else {
            throw new Error("Board parser missing error");
        }
    }
}
}

class Singleton {
}