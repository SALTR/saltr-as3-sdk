/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.matching {
import saltr.game.SLTLevel;
import saltr.game.SLTLevelParser;

public class SLTMatchingLevel extends SLTLevel {
    public function SLTMatchingLevel(id:String, index:int, localIndex:int, packIndex:int, contentUrl:String, properties:Object, version:String) {
        super(id, index, localIndex, packIndex, contentUrl, properties, version);
    }

    public function getBoard(id:String):SLTMatchingBoard {
        return _boards[id];
    }

    override protected function getParser():SLTLevelParser {
        //TODO @GSAR: make parsers singleton!
        return new SLTMatchingLevelParser();
    }
}
}
