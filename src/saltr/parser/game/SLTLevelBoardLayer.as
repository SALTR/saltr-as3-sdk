/**
 * User: gsar
 * Date: 5/2/14
 * Time: 10:41 AM
 */
package saltr.parser.game {
public class SLTLevelBoardLayer {
    private var _cells:SLTCellMatrix;

    public function SLTLevelBoardLayer(cells:SLTCellMatrix) {
        _cells = cells;
    }


    public function get cells():SLTCellMatrix {
        return _cells;
    }

}
}
