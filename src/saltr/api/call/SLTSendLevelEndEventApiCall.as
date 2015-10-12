package saltr.api.call {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTSendLevelEndEventApiCall extends SLTApiCall {

    public function SLTSendLevelEndEventApiCall(isMobile:Boolean = true):void {
        super(isMobile);
    }

    override saltr_internal function buildCall():URLVariables {
        _url = SLTConfig.SALTR_DEVAPI_URL;
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
        for (var i:int = 0, numLength:int = numericArray.length; i < numLength; i++) {
            var key:String = "cD" + (i + 1);
            eventProps[key] = numericArray[i];
        }
        for (var j:int = 0, textLength:int = textArray.length; j < length; j++) {
            var key_j:String = "cT" + (j + 1);
            eventProps[key_j] = textArray[j];
        }
        return eventProps;
    }
}
}