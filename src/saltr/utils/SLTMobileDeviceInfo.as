/**
 * Created by TIGR on 12/5/14.
 */
package saltr.utils {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.system.Capabilities;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTMobileDeviceInfo class provides mobile device information.
 * @private
 */
public class SLTMobileDeviceInfo {
    private static const IPHONE_VERSIONS:Object = {
        "iPhone1,1": "1",
        "iPhone1,2": "3G",
        "iPhone2,1": "3GS",
        "iPhone3,1": "4",
        "iPhone3,2": "4",
        "iPhone3,3": "4",
        "iPhone4,1": "4S",
        "iPhone5,1": "5",
        "iPhone5,2": "5",
        "iPhone5,3": "5C",
        "iPhone5,4": "5C",
        "iPhone6,1": "5S",
        "iPhone6,2": "5S",
        "iPhone7,2": "6",
        "iPhone7,1": "6+"
    };
    private static const IPAD_VERSIONS:Object = {
        "iPad1,1": "1",
        "iPad2,1": "2",
        "iPad2,2": "2",
        "iPad2,3": "2",
        "iPad2,4": "2",
        "iPad2,5": "Mini 1",
        "iPad2,6": "Mini 1",
        "iPad2,7": "Mini 1",
        "iPad3,1": "3",
        "iPad3,2": "3",
        "iPad3,3": "3",
        "iPad3,4": "4",
        "iPad3,5": "4",
        "iPad3,6": "4",
        "iPad4,1": "Air",
        "iPad4,2": "Air",
        "iPad4,3": "Air",
        "iPad4,4": "Mini 2",
        "iPad4,5": "Mini 2",
        "iPad4,6": "Mini 2",
        "iPad4,7": "Mini 3",
        "iPad4,8": "Mini 3",
        "iPad4,9": "Mini 3",
        "iPad5,3": "Air 2",
        "iPad5,4": "Air 2"
    };
    private static const IPOD_VERSIONS:Object = {
        "iPod1,1": "1",
        "iPod2,1": "2",
        "iPod3,1": "3",
        "iPod4,1": "4",
        "iPod5,1": "5"
    };

    private static const ANDROID_PROP_FILE:String = "/system/build.prop";
    private static const ANDROID_KEY_OS_NAME:String = "net.bt.name";
    private static const ANDROID_KEY_OS_VERSION:String = "ro.build.version.release";
    private static const ANDROID_KEY_BRAND:String = "ro.product.brand";
    private static const ANDROID_KEY_MODEL:String = "ro.product.model";
    public static const ANDROID_INFO_KEYS:Array = [ANDROID_KEY_OS_NAME, ANDROID_KEY_OS_VERSION, ANDROID_KEY_BRAND, ANDROID_KEY_MODEL];

    private static const UNKNOWN_VALUE:String = "Unknown";

    /**
     * Class constructor.
     */
    public function SLTMobileDeviceInfo() {
    }

    /**
     * Provides device information.
     * @return An object with fields(os, device).
     */
    saltr_internal static function getDeviceInfo():Object {
        var deviceInfo:Object = {};
        var os:String = Capabilities.os;
        var devArr:Array;
        var internalName:String;
        var iosDevice:String;
        var osVersion:String;
        var osName:String;

        // Windows, Windows mobile, Mac hook
        if (null != os.match("Windows") || null != os.match("Mac")) {
            deviceInfo.os = "";
            deviceInfo.device = "";
            osName = "";
            deviceInfo.deviceType = "Desktop";
        } else if (null != os.match("iPad") || null != os.match("iPhone") || null != os.match("iPod")) {
            devArr = os.split(" ");
            internalName = devArr.pop();
            deviceInfo.deviceType = internalName;
            iosDevice = (internalName.indexOf(",") > -1) ? internalName.split(",").shift() : UNKNOWN_VALUE;
            osVersion = devArr.pop();
            osName = "iOS";
            deviceInfo.os = osName + " " + osVersion;
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
            var androidInfo:Object = getAndroidInfo();

            osName = androidInfo.hasOwnProperty(ANDROID_KEY_OS_NAME) ? androidInfo[ANDROID_KEY_OS_NAME] : null;
            osVersion = androidInfo.hasOwnProperty(ANDROID_KEY_OS_VERSION) ? androidInfo[ANDROID_KEY_OS_VERSION] : null;

            if (null != osName && null != osVersion) {
                deviceInfo.os = osName + " " + osVersion;
            } else {
                deviceInfo.os = UNKNOWN_VALUE;
            }

            var deviceBrand:String = androidInfo.hasOwnProperty(ANDROID_KEY_BRAND) ? androidInfo[ANDROID_KEY_BRAND] : null;
            var deviceModel:String = androidInfo.hasOwnProperty(ANDROID_KEY_MODEL) ? androidInfo[ANDROID_KEY_MODEL] : null;
            deviceInfo.deviceType = deviceModel;
            if (null == deviceBrand && null == deviceModel) {
                deviceInfo.device = UNKNOWN_VALUE;
            } else {
                var deviceValue:String;
                if (null != deviceBrand) {
                    deviceValue = deviceBrand;
                }
                if (null != deviceModel) {
                    deviceValue += " " + deviceModel;
                }
                deviceInfo.device = deviceValue;
            }
        }
        deviceInfo.version = osVersion;
        deviceInfo.osName = osName;
        return deviceInfo;
    }

    private static function getAndroidInfo():Object {
        var propertyFile:File = new File();
        propertyFile.nativePath = ANDROID_PROP_FILE;

        var fs:FileStream = new FileStream();
        fs.open(propertyFile, FileMode.READ);

        var content:String = fs.readUTFBytes(fs.bytesAvailable);
        content = content.replace(File.lineEnding, "\n");
        fs.close();

        var pattern:RegExp = /\r?\n/;
        var lines:Array = content.split(pattern);

        var infoData:Object = {};
        for (var i:int = 0, length:int = lines.length; i < length; ++i) {
            var line:String = String(lines[i]);
            if ("" != line) {
                if (-1 == line.search("#")) {
                    for (var j:int = 0, InfoKeysLength:int = ANDROID_INFO_KEYS.length; j < InfoKeysLength; ++j) {
                        if (-1 != line.search(ANDROID_INFO_KEYS[j])) {
                            infoData[ANDROID_INFO_KEYS[j]] = line.split("=")[1];
                            break;
                        }
                    }
                }
            }
        }
        return infoData;
    }
}
}