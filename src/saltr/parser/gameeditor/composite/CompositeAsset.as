/**
 * User: sarg
 * Date: 8/2/13
 * Time: 3:08 PM
 */
package saltr.parser.gameeditor.composite {
import saltr.parser.gameeditor.BoardAsset;

public class CompositeAsset extends BoardAsset {
    private var _shifts:Array;

    public function CompositeAsset() {
    }

    public function get shifts():Array {
        return _shifts;
    }

    public function set shifts(value:Array):void {
        _shifts = value;
    }
}
}
