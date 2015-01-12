/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import flash.utils.Dictionary;

/**
 * The SLTLevelParser class represents the level parser.
 */
public class SLTLevelParser {

    /**
     * Class constructor.
     */
    public function SLTLevelParser() {
    }

    /**
     * Parses the level content.
     */
    public function parseLevelContent(boardNodes:Object, assetMap:Dictionary):Dictionary {
        throw new Error("[SALTR: ERROR] parseLevelContent() is virtual method.");
    }


    /**
     * Parses the level assets.
     */
    public function parseLevelAssets(rootNode:Object):Dictionary {
        var assetNodes:Object = rootNode["assets"];
        var assetMap:Dictionary = new Dictionary();
        for (var assetId:Object in assetNodes) {
            assetMap[assetId] = parseAsset(assetNodes[assetId]);
        }
        return assetMap;
    }

    //Parsing assets here
    private function parseAsset(assetNode:Object):SLTAsset {
        var token:String;
        var statesMap:Dictionary;
        var properties:Object = null;

        if (assetNode.hasOwnProperty("token")) {
            token = assetNode.token;
        }

        if (assetNode.hasOwnProperty("states")) {
            statesMap = parseAssetStates(assetNode.states);
        }

        if (assetNode.hasOwnProperty("properties")) {
            properties = assetNode.properties;
        }

        return new SLTAsset(token, statesMap, properties);
    }

    private function parseAssetStates(stateNodes:Object):Dictionary {
        var statesMap:Dictionary = new Dictionary();
        for (var stateId:Object in stateNodes) {
            statesMap[stateId] = parseAssetState(stateNodes[stateId]);
        }

        return statesMap;
    }

    protected function parseAssetState(stateNode:Object):SLTAssetState {
        var token:String;
        var properties:Object = null;

        if (stateNode.hasOwnProperty("token")) {
            token = stateNode.token;
        }

        if (stateNode.hasOwnProperty("properties")) {
            properties = stateNode.properties;
        }

        return new SLTAssetState(token, properties);
    }

}
}
