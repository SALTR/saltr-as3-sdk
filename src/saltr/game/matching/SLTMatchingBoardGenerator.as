/**
 * Created by TIGR on 3/25/2015.
 */
package saltr.game.matching {
import saltr.saltr_internal;

use namespace saltr_internal;

internal class SLTMatchingBoardGenerator extends SLTMatchingBoardGeneratorBase {
    private static var sInstance:SLTMatchingBoardGenerator;

    saltr_internal static function getInstance():SLTMatchingBoardGenerator {
        if (!sInstance) {
            sInstance = new SLTMatchingBoardGenerator();
        }
        return sInstance;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private var _boardConfig:SLTMatchingBoardConfig;
    private var _layer:SLTMatchingBoardLayer;

    public function SLTMatchingBoardGenerator() {
        if (sInstance) {
            throw new Error("Class cannot be instantiated. Please use the method called getInstance.");
        }
    }

    override saltr_internal function generate(boardConfig:SLTMatchingBoardConfig, layer:SLTMatchingBoardLayer):void {
        _boardConfig = boardConfig;
        _layer = layer;
        parseFixedAssets(layer, _boardConfig.cells, _boardConfig.assetMap);
        generateAssetData(_layer.chunks);
        fillLayerChunkAssets(_layer.chunks);
    }
}
}
