/**
 * Created by Tigran Hakobyan on 3/25/2015.
 */
package saltr.game.matching {
import saltr.saltr_internal;

use namespace saltr_internal;

internal class SLTMatchingBoardLayerImpl {
    private var _layer:SLTMatchingBoardLayer;
    private var _matchingRulesEnabled:Boolean;
    private var _matchSize:int;

    public function SLTMatchingBoardLayerImpl(layer:SLTMatchingBoardLayer, matchingRulesEnabled:Boolean, matchSize:int) {
        _layer = layer;
        _matchingRulesEnabled = matchingRulesEnabled;
        _matchSize = matchSize;
    }

    saltr_internal function get chunks():Vector.<SLTChunk> {
        return _layer.chunks;
    }

    saltr_internal function get matchingRulesEnabled():Boolean {
        return _matchingRulesEnabled;
    }

    saltr_internal function get matchSize():int {
        return _matchSize;
    }

    saltr_internal function generateAssetData():void {
        for (var i:int = 0, len:int = _layer.chunks.length; i < len; ++i) {
            _layer.chunks[i].generateAssetData();
        }
    }

    saltr_internal function getChunkWithCellPosition(col:uint, row:uint):SLTChunk {
        var chunkFound:SLTChunk = null;
        for each(var chunk:SLTChunk in _layer.chunks) {
            if(chunk.hasCellWithPosition(col, row)) {
                chunkFound = chunk;
                break;
            }
        }
        return chunkFound;
    }

    saltr_internal function get token():String {
        return _layer.token;
    }
}
}
