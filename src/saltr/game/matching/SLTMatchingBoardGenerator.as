/**
 * Created by Tigran Hakobyan on 3/25/2015.
 */
package saltr.game.matching {
import saltr.saltr_internal;

use namespace saltr_internal;

internal class SLTMatchingBoardGenerator extends SLTMatchingBoardGeneratorBase {
    private static var INSTANCE:SLTMatchingBoardGenerator;

    private var _boardConfig:SLTMatchingBoardConfig;
    private var _layer:SLTMatchingBoardLayer;

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

    override public function generate(boardConfig:SLTMatchingBoardConfig, layer:SLTMatchingBoardLayer):void {
        _boardConfig = boardConfig;
        _layer = layer;
        parseFixedAssets(layer, [], _boardConfig.cells, _boardConfig.assetMap);
        generateAssetData(layer);
        fillLayerChunkAssets();
    }

    private function fillLayerChunkAssets():void {
        var chunks:Vector.<SLTChunk> = _layer.chunks;
        for (var i:uint = 0; i < chunks.length; ++i) {
            var chunk:SLTChunk = chunks[i];
            var availableAssetData:Vector.<SLTChunkAssetDatum> = chunk.availableAssetData.concat();
            var chunkCells:Vector.<SLTCell> = chunk.cells.concat();
            for (var j:uint = 0; j < chunkCells.length; ++j) {
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