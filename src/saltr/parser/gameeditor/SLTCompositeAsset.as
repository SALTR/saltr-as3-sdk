/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor {
public class SLTCompositeAsset extends SLTAsset {

    private var _cellInfos:Array;

    public function SLTCompositeAsset(cellInfos:Array, type:String, keys:Object) {
        super(type, keys);
        _cellInfos = cellInfos;
    }

    public function get cellInfos():Array {
        return _cellInfos;
    }
}
}
