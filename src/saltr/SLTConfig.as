/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTConfig {

    saltr_internal static const ACTION_GET_APP_DATA:String = "getAppData";
    saltr_internal static const ACTION_ADD_PROPERTIES:String = "addProperties";
    saltr_internal static const ACTION_DEV_SYNC_DATA:String = "sync";
    saltr_internal static const ACTION_DEV_REGISTER_DEVICE:String = "registerDevice";
    saltr_internal static const ACTION_DEV_REGISTER_USER:String = "registerUser";
    saltr_internal static const ACTION_DEV_ADD_LEVELEND_EVENT:String = "addLevelEndEvent";
    saltr_internal static const ACTION_HEARTBEAT:String = "heartbeat";

    saltr_internal static const SALTR_API_URL:String = "https://api.saltr.com/call";
    saltr_internal static const SALTR_DEVAPI_URL:String = "https://devapi.saltr.com/call";

    //used to
    saltr_internal static const APP_DATA_URL_CACHE:String = "app_data_cache.json";
    saltr_internal static const LOCAL_LEVELPACK_PACKAGE_URL:String = "saltr/level_packs.json";
    saltr_internal static const LOCAL_LEVEL_CONTENT_PACKAGE_URL_TEMPLATE:String = "saltr/pack_{0}/level_{1}.json";
    saltr_internal static const LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE:String = "pack_{0}_level_{1}.json";

    saltr_internal static const RESULT_SUCCEED:String = "SUCCEED";
    saltr_internal static const RESULT_ERROR:String = "FAILED";

    saltr_internal static const DEVICE_TYPE_IPAD:String = "ipad";
    saltr_internal static const DEVICE_TYPE_IPHONE:String = "iphone";
    saltr_internal static const DEVICE_TYPE_IPOD:String = "ipod";
    saltr_internal static const DEVICE_TYPE_ANDROID:String = "android";
    saltr_internal static const DEVICE_PLATFORM_ANDROID:String = "android";
    saltr_internal static const DEVICE_PLATFORM_IOS:String = "ios";

    saltr_internal static const HEARTBEAT_TIMER_DELAY:Number = 30000;
}
}
