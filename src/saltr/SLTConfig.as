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
    saltr_internal static const DEFAULT_CONTENT_ROOT:String = "saltr";
    saltr_internal static const DEFAULT_GAME_LEVELS_FEATURE_TOKEN:String = "GAME_LEVELS";
    saltr_internal static const CACHE_VERSIONED_CONTENT_ROOT_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_{0}";
    saltr_internal static const CACHE_VERSIONED_APP_DATA_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_{0}/app_data_cache.json";
    saltr_internal static const CACHE_VERSIONED_LEVEL_VERSIONS_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_{0}/features/{1}/level_versions.json";
    saltr_internal static const CACHE_VERSIONED_LEVEL_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_{0}/features/{1}/level_{2}.json";

    saltr_internal static const LOCAL_LEVEL_DATA_URL_TEMPLATE:String = "{0}/features/{1}/level_data.json";
    saltr_internal static const LOCAL_LEVEL_CONTENT_URL_TEMPLATE:String = "{0}/features/{1}/level_{2}.json";
    saltr_internal static const LOCAL_APP_DATA_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_data.json";
    //saltr_internal static const LOCAL_LEVEL_CONTENT_PACKAGE_URL_TEMPLATE:String = "saltr/pack_{0}/level_{1}.json";
    //saltr_internal static const LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE:String = "pack_{0}_level_{1}.json";

    saltr_internal static const RESULT_SUCCEED:String = "SUCCEED";
    saltr_internal static const RESULT_ERROR:String = "FAILED";

    saltr_internal static const DEVICE_TYPE_IPAD:String = "ipad";
    saltr_internal static const DEVICE_TYPE_IPHONE:String = "iphone";
    saltr_internal static const DEVICE_TYPE_IPOD:String = "ipod";
    saltr_internal static const DEVICE_TYPE_ANDROID:String = "android";
    saltr_internal static const DEVICE_PLATFORM_ANDROID:String = "android";
    saltr_internal static const DEVICE_PLATFORM_IOS:String = "ios";

    saltr_internal static const HEARTBEAT_TIMER_DELAY:Number = 120000;

    saltr_internal static const FEATURE_TYPE_GENERIC:String = "generic";
    saltr_internal static const FEATURE_TYPE_LEVEL_COLLECTION:String = "levelCollection";
}
}
