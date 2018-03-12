/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
use namespace saltr_internal;

/**
 * @private
 */
public class SLTConfig {
    saltr_internal static const ACTION_GET_APP_DATA:String = "getAppData";
    saltr_internal static const ACTION_ADD_PROPERTIES:String = "addProperties";
    saltr_internal static const ACTION_DEV_ADD_LEVELEND_EVENT:String = "addLevelEndEvent";
    saltr_internal static const ACTION_HEARTBEAT:String = "heartbeat";
    saltr_internal static const ACTION_LEVEL_REPORT:String = "levelReport";

    saltr_internal static const SALTR_API_URL:String = "https://api.saltr.com/call";
    saltr_internal static const SALTR_DEVAPI_URL:String = "https://devapi.saltr.com/call";
    saltr_internal static const HEARTBEAT_TIMER_DELAY:Number = 120000.0;

}
}
