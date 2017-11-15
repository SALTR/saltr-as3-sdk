/**
 * Created by tyom on 6/27/2017.
 */
package saltr {
import flash.utils.Dictionary;

use namespace saltr_internal;

public class SLTLocalizationData {

    private var _languages:Dictionary;

    public function SLTLocalizationData() {
    }

    public function get languages():Dictionary {
        return _languages;
    }

    saltr_internal function get allLocales():Array {
        var result : Array = [];
        for (var key:String in _languages) {
            result.push(_languages[key]);
        }

        return result;
    }

    public function initWithData(data:Object):void {
        try {
            _languages = SLTDeserializer.decodeLocalization(data);
        } catch (e:Error) {
            throw new Error("Localization parse error");
        }
    }
}
}
