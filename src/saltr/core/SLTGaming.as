package saltr.core {
import saltr.ISLTSaltr;
import saltr.SLTLevelData;
import saltr.game.SLTLevel;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTGaming {

    private static var INSTANCE:SLTGaming;

    public static function getInstance():SLTGaming {
        if (!INSTANCE) {
            INSTANCE = new SLTGaming();
        }
        return INSTANCE;
    }

    private var _saltr:ISLTSaltr;

    public function set saltr(saltr:ISLTSaltr):void {
        _saltr = saltr;
    }

    public function getGameLevelFeatureProperties(token:String):SLTLevelData {
        return _saltr.appData.getGameLevelsProperties(token);
    }

    public function initLevelContent(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function, fromSaltr:Boolean = false):void {
        _saltr.initLevelContent(gameLevelsFeatureToken, sltLevel, callback, fromSaltr);
    }

    public function sendLevelReport(successCallback:Function, failCallback:Function, properties:Object):void {
        _saltr.sendLevelReport(successCallback, failCallback, properties);
    }
}
}
