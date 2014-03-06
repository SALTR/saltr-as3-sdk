/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import flash.geom.Point;
import flash.utils.Dictionary;

import saltr.parser.data.Vector2D;
import saltr.parser.gameeditor.BoardData;
import saltr.parser.gameeditor.Cell;

public class Composite {
    private var _id:String;
    private var _cell:Cell;
    private var _boardAssetMap:Dictionary;

    public function Composite(id:String, cell:Cell, boardData:BoardData) {
        _id = id;
        _cell = cell;
        _boardAssetMap = boardData.assetMap;
    }

    public function get id():String {
        return _id;
    }

    public function generate():void {
        var compositeAssetTemplate:CompositeAsset = _boardAssetMap[id] as CompositeAsset;
        var compositeAsset:CompositeInstance = new CompositeInstance();
        compositeAsset.keys = compositeAssetTemplate.keys;
        compositeAsset.type = compositeAssetTemplate.type;
        compositeAsset.shifts = compositeAssetTemplate.shifts;
        _cell.boardAsset = compositeAsset;
    }
}
}
