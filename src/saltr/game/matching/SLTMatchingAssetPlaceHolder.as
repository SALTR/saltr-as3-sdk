/**
 * Created by daal on 1/14/16.
 */
package saltr.game.matching {
import saltr.game.SLTAssetPlaceHolder;

public class SLTMatchingAssetPlaceHolder extends SLTAssetPlaceHolder {

    private var _col:int;
    private var _row:int;

    public function SLTMatchingAssetPlaceHolder(col:int, row:int, tags:Array) {
        super(tags);
        _col = col;
        _row = row;
    }

    public function get col():int {
        return _col;
    }

    public function get row():int {
        return _row;
    }
}
}
