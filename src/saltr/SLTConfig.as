/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
internal class SLTConfig {

    public static const ACTION_GET_APP_DATA:String = "getAppData";
    public static const ACTION_ADD_PROPERTIES:String = "addProperties";
    public static const ACTION_DEV_SYNC_DATA:String = "sync";
    public static const ACTION_DEV_REGISTER_DEVICE:String = "registerDevice";
    public static const ACTION_DEV_REGISTER_USER:String = "registerUser";
    public static const ACTION_DEV_ADD_LEVELEND_EVENT:String = "addLevelEndEvent";
    public static const SALTR_API_URL:String = "https://api.saltr.com/call";
    public static const SALTR_DEVAPI_URL:String = "https://devapi.saltr.com/call";

    //used to
    public static const APP_DATA_URL_CACHE:String = "app_data_cache.json";
    public static const LOCAL_LEVELPACK_PACKAGE_URL:String = "saltr/level_packs.json";
    public static const LOCAL_LEVEL_CONTENT_PACKAGE_URL_TEMPLATE:String = "saltr/pack_{0}/level_{1}.json";
    public static const LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE:String = "pack_{0}_level_{1}.json";

    public static const RESULT_SUCCEED:String = "SUCCEED";
    public static const RESULT_ERROR:String = "FAILED";

    public static const DEVICE_TYPE_IPAD:String = "ipad";
    public static const DEVICE_TYPE_IPHONE:String = "iphone";
    public static const DEVICE_TYPE_IPOD:String = "ipod";
    public static const DEVICE_TYPE_ANDROID:String = "android";
    public static const DEVICE_PLATFORM_ANDROID:String = "android";
    public static const DEVICE_PLATFORM_IOS:String = "ios";
}
}
