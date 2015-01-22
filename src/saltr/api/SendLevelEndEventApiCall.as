package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;

public class SendLevelEndEventApiCall extends ApiCall {
    public function SendLevelEndEventApiCall(params:Object):void {
        super(params);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override protected function buildCall():URLVariables {
        var urlVars : URLVariables = new URLVariables();
        urlVars.action = SLTConfig.ACTION_DEV_ADD_LEVELEND_EVENT;

        var args:Object = {
            clientKey : _params.clientKey,
            client : SLTSaltrMobile.CLIENT,
            devMode : _params.devMode,
            variationId : _params.variationId
        }

        //required for Mobile
        if (_params.deviceId != null) {
            args.deviceId = _params.deviceId;
            urlVars.deviceId = _params.deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

        //optional for Mobile
        if (_params.socialId != null) {
            args.socialId = _params.socialId;
        }

        var eventProps : Object = {};
        args.eventProps = eventProps;
        eventProps.endReason = _params.endReason;
        eventProps.endStatus = _params.endStatus;
        eventProps.score = _params.score;
        addLevelEndEventProperties(eventProps,_params.customNumbericProperties, _params.customTextProperties);


        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }

    private function addLevelEndEventProperties(eventProps:Object, numericArray:Array, textArray:Array) : Object {
        for(var i:int =0; i < numericArray.length; i++) {
            var key:String = "cD" + (i+1);
            eventProps[key] = numericArray[i];
        }
        for(var i:int =0; i < textArray.length; i++) {
            var key:String = "cT" + (i+1);
            eventProps[key] = textArray[i];
        }
        return eventProps;
    }
}
}