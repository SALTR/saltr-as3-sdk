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

    public static const COMMAND_APP_DATA:String = "APPDATA";
    public static const COMMAND_ADD_PROPERTY:String = "ADDPROP";
    public static const COMMAND_SAVE_OR_UPDATE_FEATURE:String = "SOUFTR";

    public static const SALTR_API_URL:String = "https://api.saltr.com/httpjson.action";
    public static const SALTR_URL:String = "https://saltr.com/httpjson.action";

    //used to
    public static const APP_DATA_URL_CACHE:String = "app_data_cache.json";
    public static const LEVEL_CONTENT_DATA_URL_LOCAL_TEMPLATE:String = "saltr/pack_{0}/level_{1}.json";
    public static const LEVEL_PACK_URL_LOCAL:String = "saltr/level_packs.json";
    public static const LEVEL_CONTENT_DATA_URL_CACHE_TEMPLATE:String = "pack_{0}_level_{1}.json";

    public static const PROPERTY_OPERATIONS_INCREMENT:String = "inc";
    public static const PROPERTY_OPERATIONS_SET:String = "set";

    protected static const RESULT_SUCCEED:String = "SUCCEED";
    protected static const RESULT_ERROR:String = "ERROR";

}
}
