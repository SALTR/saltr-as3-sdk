/**
 * Created by TIGR Hakobyan on 9/14/2015.
 */
package saltr.game {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTBoardParser {

    /**
     * Class constructor.
     */
    public function SLTBoardParser() {
    }

    saltr_internal function parseAssetState(stateNode:Object):SLTAssetState {
        throw new Error("[SALTR: ERROR] parseAssetState() is virtual method.");
    }

    saltr_internal function parseBoardContent(rootNode:Object, assetMap:Dictionary):Dictionary {
        throw new Error("[SALTR: ERROR] parseBoardContent() is virtual method.");
    }

    protected final function parseBoardProperties(boardNode:Object):Dictionary {
        var boardProperties:Dictionary = new Dictionary();
        if (boardNode.hasOwnProperty(SLTLevelParser.NODE_PROPERTY_OBJECTS)) {
            var propertyNodes:Object = boardNode[SLTLevelParser.NODE_PROPERTY_OBJECTS];
            for (var propertyToken:String in propertyNodes) {
                boardProperties[propertyToken] = propertyNodes[propertyToken];
            }
        }
        return boardProperties;
    }

    protected final function getBoardsNode(rootNode:Object, type:String):Object {
        var boardsNode:Object = null;
        if (rootNode.hasOwnProperty("boards") && rootNode["board"].hasOwnProperty(type)) {
            boardsNode = rootNode["boards"][type];
        }
        return boardsNode;
    }
}
}
