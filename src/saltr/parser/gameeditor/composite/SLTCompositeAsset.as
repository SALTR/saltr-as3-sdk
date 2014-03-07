/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import saltr.parser.gameeditor.SLTAsset;

public class SLTCompositeAsset extends SLTAsset {

    private var _shifts:Array;

    public function SLTCompositeAsset(shifts:Array, typeKey:String, keys:Object) {
        super(typeKey, keys);
        _shifts = shifts;
    }

    public function get shifts():Array {
        return _shifts;
    }
}
}
