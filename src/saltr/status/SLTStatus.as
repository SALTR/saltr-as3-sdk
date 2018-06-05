/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {

/**
 * The SLTStatus class represents the status information of an operation performed by SDK.
 */
public class SLTStatus {

    /**
     * Specifies the authorization error.
     */
    public static const AUTHORIZATION_ERROR:int = 1001;

    /**
     * Specifies the validation error.
     */
    public static const VALIDATION_ERROR:int = 1002;

    /**
     * Specifies the API error.
     */
    public static const API_ERROR:int = 1003;

    /**
     * Specifies the parse error.
     */
    public static const PARSE_ERROR:int = 1004;


    /**
     * Specifies the registration required error.
     */
    public static const REGISTRATION_REQUIRED_ERROR_CODE:int = 2001;

    /**
     * Specifies the client error.
     */
    public static const CLIENT_ERROR_CODE:int = 2002;


    /**
     * Specifies the client app data load fail.
     */
    public static const CLIENT_APP_DATA_LOAD_FAIL:int = 2040;

    /**
     * Specifies the client level content load fail.
     */
    public static const CLIENT_LEVEL_CONTENT_LOAD_FAIL:int = 2041;

    /**
     * Specifies the client app data concurrent load refused.
     */
    public static const CLIENT_APP_DATA_CONCURRENT_LOAD_REFUSED:int = 2042;

    /**
     * Specifies the client features parse error.
     */
    public static const CLIENT_FEATURES_PARSE_ERROR:int = 2050;

    /**
     * Specifies the client experiments parse error.
     */
    public static const CLIENT_EXPERIMENTS_PARSE_ERROR:int = 2051;

    /**
     * Specifies the client board parse error.
     */
    public static const CLIENT_BOARD_PARSE_ERROR:int = 2052;


    /**
     * Specifies the client app data parse error.
     */
    public static const CLIENT_APP_DATA_PARSE_ERROR:int = 2053;

    /**
     * Specifies the client level parse error.
     */
    public static const CLIENT_LEVELS_PARSE_ERROR:int = 2054;

    private var _statusCode:int;
    private var _statusMessage:String;

    /**
     * Class constructor.
     * @param code The status code.
     * @param message The status message.
     */
    public function SLTStatus(code:int, message:String) {
        _statusCode = code;
        _statusMessage = message;
        trace("[SALTR] " + message);
    }

    /**
     * The status message.
     */
    public function get statusMessage():String {
        return _statusMessage;
    }

    /**
     * The status code.
     */
    public function get statusCode():int {
        return _statusCode;
    }
}
}
