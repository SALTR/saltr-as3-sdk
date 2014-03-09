/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import saltr.parser.gameeditor.SLTAsset;

public class SLTCompositeAsset extends SLTAsset {

    private var _cells:Array;

    public function SLTCompositeAsset(cells:Array, type:String, keys:Object) {
        super(type, keys);
        _cells = cells;
    }

    public function get cells():Array {
        return _cells;
    }
}
}
