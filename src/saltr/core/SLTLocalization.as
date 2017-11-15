package saltr.core {
import saltr.ISLTSaltr;
import saltr.lang.SLTLocale;

public class SLTLocalization {

    private static var INSTANCE:SLTLocalization;

    private var _saltr:ISLTSaltr;

    public static function getInstance():SLTLocalization {
        if (!INSTANCE) {
            INSTANCE = new SLTLocalization();
        }
        return INSTANCE;
    }

    public function set saltr(value:ISLTSaltr):void {
        _saltr = value;
    }

    public function initLanguageContent(token:String, sltLocale:SLTLocale, callback:Function, fromSaltr:Boolean = false):void {
        _saltr.initLanguageContent(token, sltLocale, callback, fromSaltr);
    }

    public function getLocalizationProperties(token:String):saltr.SLTLocalizationData {
        return _saltr.getLocalizationProperties(token);
    }

    public function getActiveLanguageList(token:String):Array {
        return _saltr.getActiveLanguageList(token);
    }
}
}