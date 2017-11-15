package saltr.core {
import saltr.ISLTSaltr;
import saltr.SLTExperiment;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTAnalytics {

    private static var INSTANCE:SLTAnalytics;

    private var _saltr:ISLTSaltr;

    public static function getInstance():SLTAnalytics {
        if (!INSTANCE) {
            INSTANCE = new SLTAnalytics();
        }
        return INSTANCE;
    }

    public function set saltr(value:ISLTSaltr):void {
        _saltr = value;
    }

    public function get experiments():Vector.<SLTExperiment> {
        _saltr.appData.experiments;
    }
}
}
