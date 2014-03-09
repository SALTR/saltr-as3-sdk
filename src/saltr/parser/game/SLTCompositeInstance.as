/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.game {
public class SLTCompositeInstance extends SLTAssetInstance {
    private var _cells:Array;

    public function SLTCompositeInstance(keys:Object, state:String, type:String, cells:Array) {
        super(keys, state, type);
        _cells = cells;
    }

    public function get cells():Array {
        return _cells;
    }

}
}
