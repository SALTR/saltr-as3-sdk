/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import flash.utils.Dictionary;

import saltr.parser.gameeditor.SLTCell;
import saltr.parser.gameeditor.SLTLevelSettings;

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
        var asset:SLTCompositeAsset = _boardAssetMap[id] as SLTCompositeAsset;
        var instance:SLTCompositeInstance = new SLTCompositeInstance();
        instance.shifts = asset.shifts;
        _cell.assetInstance = instance;
    }
}
}
