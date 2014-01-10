/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: gsar
 * Date: 4/12/13
 * Time: 8:25 PM
 */
package saltr {
import plexonic.device.Agent;
import plexonic.network.NetworkMonitor;

//TODO @GSAR: try to merge with Saltr
public class MobileSaltr extends Saltr {
    private static var INSTANCE:MobileSaltr = null;
    private var _deviceDTO:DeviceDTO;

    public static function getInstance():MobileSaltr {
        if (INSTANCE == null) {
            INSTANCE = new MobileSaltr();
        }
        return INSTANCE;
    }

    public function MobileSaltr() {
        super();
    }

    override public function get userId():String {
        return _deviceDTO.deviceId;
    }

    override public function init(instanceKey:String):void {
        super.init(instanceKey);
        _deviceDTO = new DeviceDTO(Agent.device.udid, "");
    }

    override public function getAppData(platform:String):void {
        trace("[SaltClient] Trying to load App data. platform=" + platform);
        if (_isLoading) {
            return;
        }
        _isLoading = true;
        _ready = false;

        trace("[SaltClient] Internet is available - so loading app data from network.");
        if (NetworkMonitor.getInstance().isReachable) {
            _api.loadAppData(_partnerDTO, _deviceDTO, _instanceKey, platform, function (data:Object):void {
                        var jsonData:Object = data.responseData;
                        trace("[SaltClient] Loaded App data. json=" + jsonData);
                        if (jsonData == null || data["status"] != Saltr.RESULT_SUCCEED) {
                            loadAppDataInternal();
                        }
                        else {
                            loadAppDataSuccessHandler(jsonData);
                            _storage.cacheObject(PACKS_DATA_URL_CACHE, "0", jsonData);
                        }

                    },
                    loadAppDataInternal
            )
        } else {
            loadAppDataInternal();
        }
    }
}
}
