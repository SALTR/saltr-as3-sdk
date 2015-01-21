package saltr.api {
import flash.net.URLVariables;

import saltr.resource.SLTResource;
import saltr.saltr_internal;

use namespace saltr_internal;

public class LevelContentApiCall extends ApiCall{
    public function LevelContentApiCall(params:Object) {
        super(params);
        //_url = SLTConfig.SALTR_API_URL;
        _url = _params.sltLevel.contentUrl + "?_time_=" + new Date().getTime();
    }

    override protected function buildCall():URLVariables {
        return null;
    }

    override protected function callRequestCompletedHandler(resource:SLTResource):void {
        var content:Object = resource.jsonData;
        var success:Boolean = false;
        var apiCallResult:ApiCallResult = new ApiCallResult();
        var data:Object = {
            sltLevel:_params.sltLevel,
            content:content
        };
        if (content != null) {
            success = true;
        }

        apiCallResult.success = success;
        apiCallResult.data = data;
        _callback(apiCallResult);
    }
}
}