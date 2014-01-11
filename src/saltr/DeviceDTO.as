/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: daal
 * Date: 12/3/12
 * Time: 5:28 PM
 */
package saltr {
//TODO @GSAR: get rid of this, or at least make it internal!
internal class DeviceDTO {

    private var _deviceId:String;
    private var _deviceType:String;

    public function DeviceDTO(deviceId:String = null, deviceType:String = null) {
        _deviceId = deviceId;

        //TODO: remove device type after it is removed from Salt Bend
        _deviceType = deviceType;
    }

    public function get deviceId():String {
        return _deviceId;
    }

    public function set deviceId(value:String):void {
        _deviceId = value;
    }

    public function get deviceType():String {
        return _deviceType;
    }

    public function set deviceType(value:String):void {
        _deviceType = value;
    }
}
}
