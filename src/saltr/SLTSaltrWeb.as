/**
 * Created by daal on 4/7/16.
 */
package saltr {

import flash.utils.ByteArray;
import flash.utils.getQualifiedClassName;

import plexonic.bugtracker.bugsnag.BugSnag;

import saltr.api.call.SLTApiCall;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.factory.SLTWebApiCallFactory;
import saltr.game.SLTLevel;
import saltr.status.SLTStatus;
import saltr.utils.gzip.SLTGzipByteArray;
import saltr.utils.gzip.SLTGzipEncoder;

use namespace saltr_internal;

public class SLTSaltrWeb extends SLTSaltr {

    private var _sltLevel:SLTLevel;
    private var _callback:Function;

    public function SLTSaltrWeb(clientKey:String, deviceId:String = null, socialId:String = null, isBinary:Boolean = false) {
        super(clientKey, deviceId, socialId, isBinary);

        SLTApiCallFactory.factory = new SLTWebApiCallFactory();
    }

    override public function start():void {
        if (_socialId == null) {
            throw new Error("socialId field is required and can't be null.");
        }
        _appData.initFeatures(getAppDataFromSnapshot());
        _started = true;
    }

    override public function initLevelContent(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function, fromSaltr:Boolean = false):void {
        super.initLevelContent(levelCollectionToken, sltLevel, callback, true);
    }

    override protected function initLevelContentFromSaltr(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        _sltLevel = sltLevel;
        _callback = callback;

        var params:Object = {
            contentUrl: sltLevel.contentUrl,
            alternateUrl: sltLevel.defaultContentUrl
        };

        var levelContentApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT);
        levelContentApiCall.call(params, levelContentLoadSuccessCallback, levelContentLoadFailCallback, _nativeTimeout, _dropTimeout, _timeoutIncrease);
    }

    private function levelContentLoadSuccessCallback(data:Object):void {
        var unCompressData:Object = null;
        if (_isBinary && data != null && data is ByteArray) {
            var byteArrayData:ByteArray = data as ByteArray;
            unCompressData = SLTGzipEncoder.uncompressToObject(new SLTGzipByteArray(byteArrayData));
            if (unCompressData == null || byteArrayData == null) {
                BugSnag.sendError("SLTSaltrWeb-> levelContentLoadSuccessCallback", "Gzip parsing fail", {
                    uncompressData: unCompressData,
                    byteArray: byteArrayData,
                    dataType: getQualifiedClassName(data),
                    isBinary: _isBinary
                }, false)
            }
        } else {
            unCompressData = data;
            if (unCompressData == null) {
                BugSnag.sendError("SLTSaltrWeb-> levelContentLoadSuccessCallback", "data is not byteArray", {
                    uncompressData: unCompressData,
                    dataType: getQualifiedClassName(data),
                    isBinary: _isBinary
                }, false);
            }
        }
        _sltLevel.updateContent(unCompressData);
        _callback(true);
    }

    private function levelContentLoadFailCallback(status:SLTStatus):void {
        _callback(false);
    }
}
}
