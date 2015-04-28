package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SendLevelEndEventApiCall extends ApiCall {

    public function SendLevelEndEventApiCall(params:Object, isMobile:Boolean = true):void {
        super(params, isMobile);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override saltr_internal function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        urlVars.action = SLTConfig.ACTION_DEV_ADD_LEVELEND_EVENT;

        var args:Object = buildDefaultArgs();
        args.variationId = _params.variationId;

        var eventProps:Object = {};
        args.eventProps = eventProps;
        eventProps.endReason = _params.endReason;
        eventProps.endStatus = _params.endStatus;
        eventProps.score = _params.score;
        addLevelEndEventProperties(eventProps, _params.customNumbericProperties, _params.customTextProperties);


        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }

    private function addLevelEndEventProperties(eventProps:Object, numericArray:Array, textArray:Array):Object {
        for (var i:int = 0; i < numericArray.length; i++) {
            var key:String = "cD" + (i + 1);
            eventProps[key] = numericArray[i];
        }
        for (var j:int = 0; j < textArray.length; j++) {
            var key_j:String = "cT" + (j + 1);
            eventProps[key_j] = textArray[j];
        }
        return eventProps;
    }
}
}