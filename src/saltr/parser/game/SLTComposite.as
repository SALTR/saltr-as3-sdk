/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
import flash.utils.Dictionary;

internal class SLTComposite {
    private var _assetId:String;
    private var _stateId:String;
    private var _cell:SLTCell;
    private var _assetMap:Dictionary;
    private var _stateMap:Dictionary;
    private var _layer:SLTLevelBoardLayer;

    public function SLTComposite(layer:SLTLevelBoardLayer, compositeAssetId:String, stateId:String, cell:SLTCell, levelSettings:SLTLevelSettings) {
        _layer = layer;
        _assetId = compositeAssetId;
        _stateId = stateId;
        _cell = cell;
        _assetMap = levelSettings.assetMap;
        _stateMap = levelSettings.stateMap;
        generateCellContent();
    }

    private function generateCellContent():void {
        var asset:SLTCompositeAsset = _assetMap[_assetId] as SLTCompositeAsset;
        var state:String = _stateMap[_stateId] as String;
        _cell.setAssetInstance(_layer.layerId, _layer.layerIndex, new SLTCompositeInstance(asset.token, state, asset.properties, asset.cellInfos));
    }
}
}
