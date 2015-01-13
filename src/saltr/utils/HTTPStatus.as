/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.utils {

/**
 * The HTTPStatus class holds HTTP status codes.
 */
public class HTTPStatus {

    /**
     * Specifies the bad request HTTP status code.
     */
    public static const HTTP_STATUS_400:int = 400;

    /**
     * Specifies the forbidden HTTP status code.
     */
    public static const HTTP_STATUS_403:int = 403;

    /**
     * Specifies the page not found HTTP status code.
     */
    public static const HTTP_STATUS_404:int = 404;

    /**
     * Specifies the internal server error HTTP status code.
     */
    public static const HTTP_STATUS_500:int = 500;

    /**
     * Specifies the internal server error HTTP status code.
     */
    public static const HTTP_STATUS_502:int = 502;

    /**
     * Specifies the bad gateway HTTP status code.
     */
    public static const HTTP_STATUS_503:int = 503;

    /**
     * Specifies the OK HTTP status code.
     */
    public static const HTTP_STATUS_OK:int = 200;

    /**
     * Specifies the not modified HTTP status code.
     */
    public static const HTTP_STATUS_NOT_MODIFIED:int = 304;

    /**
     * Specifies the success HTTP status code collection.
     */
    public static const HTTP_SUCCESS_CODES:Vector.<int> = Vector.<int>([HTTP_STATUS_OK]);

    /**
     * Checks the HTTP status code successes.
     * @param statusCode The HTTP status code to check.
     * @return <code>true</code> if provided http status code is success code.
     */
    public static function isInSuccessCodes(statusCode:int):Boolean {
        return HTTP_SUCCESS_CODES.indexOf(statusCode) != -1;
    }
}
}
