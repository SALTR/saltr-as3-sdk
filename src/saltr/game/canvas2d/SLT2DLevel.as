/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import saltr.game.SLTLevel;
import saltr.game.SLTLevelParser;

public class SLT2DLevel extends SLTLevel {
    public function SLT2DLevel(id:String, index:int, localIndex:int, packIndex:int, contentUrl:String, properties:Object, version:String) {
        super(id, index, localIndex, packIndex, contentUrl, properties, version);
    }

    public function getBoard(id:String):SLT2DBoard {
        return _boards[id];
    }

    override protected function getParser():SLTLevelParser {
        return new SLT2DLevelParser();
    }
}
}
