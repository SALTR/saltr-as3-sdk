/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: daal
 * Date: 3/9/14
 * Time: 7:34 PM
 */
package saltr {
internal class SLTConfig {

    public static const CMD_APP_DATA:String = "getAppData";
    public static const CMD_ADD_PROPERTY:String = "addProperty";
    public static const CMD_DEV_SYNC_FEATURES:String = "syncFeatures";

    public static const SALTR_API_URL:String = "https://api.saltr.com/httpjson.action";
    public static const SALTR_DEVAPI_URL:String = "https://devapi.saltr.com/call.action";

    //used to
    public static const APP_DATA_URL_CACHE:String = "app_data_cache.json";
    public static const LOCAL_LEVELPACK_PACKAGE_URL:String = "saltr/level_packs.json";
    public static const LOCAL_LEVEL_CONTENT_PACKAGE_URL_TEMPLATE:String = "saltr/pack_{0}/level_{1}.json";
    public static const LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE:String = "pack_{0}_level_{1}.json";

    public static const PROPERTY_OPERATIONS_INCREMENT:String = "inc";
    public static const PROPERTY_OPERATIONS_SET:String = "set";

    public static const RESULT_SUCCEED:String = "SUCCEED";
    public static const RESULT_ERROR:String = "FAILED";

}
}
