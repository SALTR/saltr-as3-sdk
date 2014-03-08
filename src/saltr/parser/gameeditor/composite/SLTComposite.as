/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import flash.geom.Point;
import flash.utils.Dictionary;

import saltr.parser.data.SLTCellMatrix;
import saltr.parser.gameeditor.SLTLevelSettings;
import saltr.parser.gameeditor.SLTCell;

public class SLTComposite {
    private var _id:String;
    private var _cell:SLTCell;
    private var _boardAssetMap:Dictionary;

    public function SLTComposite(id:String, cell:SLTCell, levelSettings:SLTLevelSettings) {
        _id = id;
        _cell = cell;
        _boardAssetMap = levelSettings.assetMap;
    }

    public function get id():String {
        return _id;
    }

    public function generate():void {
        var compositeAssetTemplate:SLTCompositeAsset = _boardAssetMap[id] as SLTCompositeAsset;
        var compositeAsset:SLTCompositeInstance = new SLTCompositeInstance();
        compositeAsset.keys = compositeAssetTemplate.keys;
        compositeAsset.type = compositeAssetTemplate.type;
        compositeAsset.shifts = compositeAssetTemplate.shifts;
        _cell.assetInstance = compositeAsset;
    }
}
}
