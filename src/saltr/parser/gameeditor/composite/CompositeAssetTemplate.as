/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import saltr.parser.gameeditor.AssetTemplate;

public class CompositeAssetTemplate extends AssetTemplate {

    private var _shifts:Array;

    public function CompositeAssetTemplate(shifts:Array, typeKey:String, keys:Object) {
        super(typeKey, keys);
        _shifts = shifts;
    }

    public function get shifts():Array {
        return _shifts;
    }
}
}
