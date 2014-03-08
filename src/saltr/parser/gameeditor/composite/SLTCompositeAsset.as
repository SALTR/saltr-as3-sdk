/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import saltr.parser.gameeditor.SLTAsset;

public class SLTCompositeAsset extends SLTAsset {

    private var _shifts:Array;

    public function SLTCompositeAsset(shifts:Array, type:String, keys:Object) {
        super(type, keys);
        _shifts = shifts;
    }

    public function get shifts():Array {
        return _shifts;
    }
}
}
