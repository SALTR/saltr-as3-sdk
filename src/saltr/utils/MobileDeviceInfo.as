/**
 * Created by TIGR on 12/5/14.
 */
package saltr.utils {
import flash.system.Capabilities;

import nl.funkymonkey.android.deviceinfo.NativeDeviceInfo;
import nl.funkymonkey.android.deviceinfo.NativeDeviceProperties;

public class MobileDeviceInfo {
    private static const IPHONE_VERSIONS:Object = {"iPhone1,1": "1", "iPhone1,2": "3G", "iPhone2,1": "3GS", "iPhone3,1": "4", "iPhone3,2": "4", "iPhone3,3": "4", "iPhone4,1": "4S", "iPhone5,1": "5", "iPhone5,2": "5","iPhone5,3": "5C", "iPhone5,4": "5C",  "iPhone6,1": "5S",  "iPhone6,2": "5S" }
    private static const IPAD_VERSIONS:Object = {"iPad1,1": "1", "iPad2,1": "2", "iPad2,2": "2", "iPad2,3": "2", "iPad2,4": "2", "iPad2,5": "Mini 1", "iPad2,6": "Mini 1", "iPad2,7": "Mini 1", "iPad3,1": "3", "iPad3,2": "3", "iPad3,3": "3", "iPad3,4": "4","iPad3,5": "4", "iPad3,6": "4", "iPad4,1": "Air", "iPad4,2": "Air", "iPad4,4": "Mini 2", "iPad4,5": "Mini 2" }
    private static const IPOD_VERSIONS:Object = {"iPod1,1": "1", "iPod2,1": "2", "iPod3,1": "3", "iPod4,1": "4", "iPod5,1": "5" }

    private static const UNKNOWN_VALUE:String = "Unknown";

    public function MobileDeviceInfo() {
    }

    /*
    Return Value: Returns an object with fields(os, device)
     */
    public static function getDeviceInfo():Object {
        var deviceInfo:Object = {};
        var os:String = Capabilities.os;
        var devArr:Array;
        var internalName:String;
        var iosDevice:String;
        var iosVersion:String;

        if(null != os.match("iPad") || null != os.match("iPhone") || null != os.match("iPod")) {
            devArr = os.split(" ");
            internalName = devArr.pop();
            iosDevice = (internalName.indexOf(",") > -1) ? internalName.split(",").shift() : UNKNOWN_VALUE;
            iosVersion = devArr.pop();
            deviceInfo.os = "iOS " + iosVersion;

            if (null != iosDevice.match(/iPhone/)) {
                deviceInfo.device = "iPhone " + IPHONE_VERSIONS[internalName];
            } else if (null != iosDevice.match(/iPod/)) {
                deviceInfo.device = "iPod " + IPOD_VERSIONS[internalName];
            } else if (null != iosDevice.match(/iPad/)) {
                deviceInfo.device = "iPad " + IPAD_VERSIONS[internalName];
            } else {
                deviceInfo.device = UNKNOWN_VALUE;
            }
        } else {
            var androidInfo:NativeDeviceInfo = new NativeDeviceInfo();
            androidInfo.setDebug(false);
            androidInfo.parse();

            var osName:String = NativeDeviceProperties.OS_NAME.value;
            var osVersion:String = NativeDeviceProperties.OS_VERSION.value;
            if(null != osName && null != osVersion) {
                deviceInfo.os = osName + " " + osVersion;
            } else {
                deviceInfo.os = UNKNOWN_VALUE;
            }

            var deviceBrand:String = NativeDeviceProperties.PRODUCT_BRAND.value;
            var deviceModel:String = NativeDeviceProperties.PRODUCT_MODEL.value;

            if(null == deviceBrand && null == deviceModel) {
                deviceInfo.device = UNKNOWN_VALUE;
            } else {
                var deviceValue:String;
                if(null != deviceBrand) {
                    deviceValue = deviceBrand;
                }
                if(null != deviceModel) {
                    deviceValue += " " + deviceModel;
                }
                deviceInfo.device = deviceValue;
            }
        }

        return deviceInfo;
    }
}
}
