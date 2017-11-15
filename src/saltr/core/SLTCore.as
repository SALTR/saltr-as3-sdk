package saltr.core {
import saltr.ISLTSaltr;
import saltr.SLTBasicProperties;
import saltr.SLTSaltrMobile;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTCore {
    private static var INSTANCE:SLTCore;

    private var _saltr:ISLTSaltr;

    public static function getInstance():SLTCore {
        if (!INSTANCE) {
            INSTANCE = new SLTCore();
        }
        return INSTANCE;
    }

    public function configure():void {
        _saltr = new SLTSaltrMobile(SLTConfig.getInstance().clientKey, SLTConfig.getInstance().deviceId);
        SLTGaming.getInstance().saltr = _saltr;
        SLTLocalization.getInstance().saltr = _saltr;
        SLTAnalytics.getInstance().saltr = _saltr;
    }

    public function start():void {
        _saltr.start();
    }

    public function getActiveFeatureTokens():Vector.<String> {
        _saltr.appData.getActiveFeatureTokens();
    }

    public function getFeatureProperties(token:String):Object {
        _saltr.appData.getFeatureProperties(token);
    }

    public function addValidator(featureToken:String, validator:Function):void {
        _saltr.addValidator(featureToken, validator);
    }

    public function addProperties(basicProperties:Object = null, customProperties:Object = null):void {
        _saltr.addProperties(basicProperties, customProperties);
    }

    public function ping(successCallback:Function = null, failCallback:Function = null):void {
        _saltr.ping(successCallback, failCallback);
    }

    public function connect(successCallback:Function, failCallback:Function, basicProperties:SLTBasicProperties, customProperties:Object = null):void {
        _saltr.connect(successCallback, failCallback, basicProperties, customProperties);
    }
}
}