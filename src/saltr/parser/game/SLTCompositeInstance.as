/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.game {
public class SLTCompositeInstance extends SLTAssetInstance {
    private var _cells:Array;

    public function SLTCompositeInstance(token:String, state:String, properties:Object, cells:Array) {
        super(token, state, properties);
        _cells = cells;
    }

    public function get cells():Array {
        return _cells;
    }

}
}
