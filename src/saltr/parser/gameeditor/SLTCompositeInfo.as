/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor {
import flash.utils.Dictionary;

public class SLTCompositeInfo {
    private var _assetId:String;
    private var _stateId:String;
    private var _cell:SLTCell;
    private var _assetMap:Dictionary;
    private var _stateMap:Dictionary;

    public function SLTCompositeInfo(compositeAssetId:String, stateId:String, cell:SLTCell, levelSettings:SLTLevelSettings) {
        _assetId = compositeAssetId;
        _stateId = stateId;
        _cell = cell;
        _assetMap = levelSettings.assetMap;
        _stateMap = levelSettings.stateMap;
    }

    public function get assetId():String {
        return _assetId;
    }

    //TODO @GSAR: why we have generate() here?
    public function generate():void {
        var asset:SLTCompositeAsset = _assetMap[_assetId] as SLTCompositeAsset;
        var state:String = _stateMap[_stateId] as String;
        _cell.assetInstance = new SLTCompositeInstance(asset.keys, state, asset.type, asset.cellInfos);
    }
}
}
