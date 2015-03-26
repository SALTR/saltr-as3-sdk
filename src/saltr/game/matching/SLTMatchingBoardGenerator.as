/**
 * Created by Tigran Hakobyan on 3/25/2015.
 */
package saltr.game.matching {
import saltr.saltr_internal;

use namespace saltr_internal;

internal class SLTMatchingBoardGenerator implements ISLTMatchingBoardGenerator {
    private static var INSTANCE:SLTMatchingBoardGenerator;

    private var _boardImpl:SLTMatchingBoardImpl;
    private var _layerImpl:SLTMatchingBoardLayerImpl;

    saltr_internal static function getInstance():SLTMatchingBoardGenerator {
        if (!INSTANCE) {
            INSTANCE = new SLTMatchingBoardGenerator(new Singleton());
        }
        return INSTANCE;
    }

    public function SLTMatchingBoardGenerator(singleton:Singleton) {
        if (singleton == null) {
            throw new Error("Class cannot be instantiated. Please use the method called getInstance.");
        }
    }

    public function generate(board:SLTMatchingBoardImpl, layer:SLTMatchingBoardLayerImpl):void {
        _boardImpl = board;
        _layerImpl = layer;
        _layerImpl.generateAssetData();
        fillLayerChunkAssets();
    }

    private function fillLayerChunkAssets():void {
        var chunks:Vector.<SLTChunk> = _layerImpl.chunks;
        for(var i:uint=0; i<chunks.length; ++i) {
            var chunk:SLTChunk = chunks[i];
            var availableAssetData:Vector.<SLTChunkAssetDatum> = chunk.availableAssetData.concat();
            var chunkCells:Vector.<SLTCell> = chunk.cells.concat();
            for(var j:uint=0; j<chunkCells.length; ++j) {
                var assetDatumRandIndex:int = Math.random() * availableAssetData.length;
                var assetDatum = availableAssetData[assetDatumRandIndex];
                availableAssetData.splice(assetDatumRandIndex, 1);
                chunk.addAssetInstanceWithCellIndex(assetDatum, j);
            }
        }
    }
}
}

class Singleton {
}