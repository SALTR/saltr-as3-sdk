/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: daal
 * Date: 3/13/14
 * Time: 12:23 PM
 */
package saltr.status {
public class SLTStatus {

    public static const AUTHORIZATION_ERROR:int = 1001;
    public static const VALIDATION_ERROR:int = 1002;
    public static const API_ERROR:int = 1003;


    public static const GENERAL_ERROR_CODE:int = 2001;
    public static const CLIENT_ERROR_CODE:int = 2002;


    public static const CLIENT_APP_DATA_LOAD_FAIL:int = 2040;
    public static const CLIENT_LEVEL_CONTENT_LOAD_FAIL:int = 2041;

    public static const CLIENT_FEATURES_PARSE_ERROR:int = 2050;
    public static const CLIENT_EXPERIMENTS_PARSE_ERROR:int = 2051;
    public static const CLIENT_LEVELS_PARSE_ERROR:int = 2052;

    private var _statusCode:int;
    private var _statusMessage:String;

    public function SLTStatus(code:int, message:String) {
        _statusCode = code;
        _statusMessage = message;
        trace(message);
    }

    public function get statusMessage():String {
        return _statusMessage;
    }

    public function get statusCode():int {
        return _statusCode;
    }
}
}
