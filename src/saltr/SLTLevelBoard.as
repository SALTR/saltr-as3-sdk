/**
 * User: hrut
 * Date: 2/11/14
 * Time: 3:01 PM
 */
package saltr {
import saltr.parser.data.SLTCellMatrix;

public class SLTLevelBoard {
    private var _rows:int;
    private var _cols:int;
    private var _cells:SLTCellMatrix;
    private var _properties:Object;

    public function SLTLevelBoard(cells:SLTCellMatrix, properties:Object) {
        _cells = cells;
        _cols = cells.width;
        _rows = cells.height;
        _properties = properties;
    }

    public function get rows():int {
        return _rows;
    }

    public function get cols():int {
        return _cols;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get cells():SLTCellMatrix {
        return _cells;
    }
}
}
