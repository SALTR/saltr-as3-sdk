/**
 * Created by tyom on 6/27/2017.
 */
package saltr {
import de.polygonal.ds.Map;

import flash.utils.Dictionary;

use namespace saltr_internal;

public class SLTLocalization {

    private var _languages:Dictionary;

    public function SLTLocalization() {
    }

    public function get languages():Dictionary {
        return _languages;
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
