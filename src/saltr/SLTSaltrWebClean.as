/**
 * Created by daal on 4/7/16.
 */
package saltr {

use namespace saltr_internal;

public class SLTSaltrWebClean extends SLTSaltr {

    public function SLTSaltrWebClean(clientKey:String, deviceId:String = null, socialId:String = null) {
        super(clientKey, deviceId, socialId);
    }

    override public function start():void {
        if (_socialId == null) {
            throw new Error("socialId field is required and can't be null.");
        }

        _appData.initEmpty();
        _started = true;
    }
}
}
