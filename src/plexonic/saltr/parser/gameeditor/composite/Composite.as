/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package plexonic.saltr.parser.gameeditor.composite {
import de.polygonal.ds.Array2;
import de.polygonal.ds.Map;

import plexonic.saltr.parser.gameeditor.BoardData;
import plexonic.saltr.parser.gameeditor.Cell;

public class Composite {
    private var _id:String;
    private var _position:Cell;
    private var _outputBoard:Array2;
    private var _boardAssetMap:Map;

    public function Composite(id:String, position:Cell, outputBoard:Array2, boardData:BoardData) {
        _id = id;
        _position = position;
        _outputBoard = outputBoard;
        _boardAssetMap = boardData.assetMap;
    }

    public function get id():String {
        return _id;
    }

    public function get position():Cell {
        return _position;
    }

    public function generate():void {
        var compositeAssetTemplate:CompositeAssetTemplate = _boardAssetMap.get(id) as CompositeAssetTemplate;
        var compositeAsset:CompositeAsset = new CompositeAsset();
        compositeAsset.keys = compositeAssetTemplate.keys;
        compositeAsset.type = compositeAssetTemplate.type;
        var cellShifts:Array = compositeAssetTemplate.shifts;
        var shift:Array;
        var shifts:Vector.<Cell> = new <Cell>[];
        for (var i:int = 0, len:int = cellShifts.length; i < len; ++i) {
            shift = cellShifts[i];
            shifts.push(new Cell(shift[0], shift[1]));
        }
        compositeAsset.shifts = shifts;
        compositeAsset.basis = new Cell(_position.x, _position.y);
        _outputBoard.set(_position.x, _position.y, compositeAsset);
    }
}
}
