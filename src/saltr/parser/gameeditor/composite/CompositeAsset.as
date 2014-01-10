/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import plexonic.saltr.parser.gameeditor.BoardAsset;
import plexonic.saltr.parser.gameeditor.Cell;

public class CompositeAsset extends BoardAsset {
    private var _shifts:Vector.<Cell>;
    private var _basis:Cell;

    public function CompositeAsset() {
    }

    public function get shifts():Vector.<Cell> {
        return _shifts;
    }

    public function set shifts(value:Vector.<Cell>):void {
        _shifts = value;
    }

    public function get basis():Cell {
        return _basis;
    }

    public function set basis(value:Cell):void {
        _basis = value;
    }
}
}
