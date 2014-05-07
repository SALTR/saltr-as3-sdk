/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: gsar
 * Date: 10/13/13
 * Time: 1:51 PM
 */
package saltr.utils {
public class HTTPStatus {

    public static const HTTP_STATUS_400:int = 400; //Bad Request
    public static const HTTP_STATUS_403:int = 403; //Forbidden
    public static const HTTP_STATUS_404:int = 404; //Page Not Found
    public static const HTTP_STATUS_500:int = 500; //Internal Server Error
    public static const HTTP_STATUS_502:int = 502; //Internal Server Error
    public static const HTTP_STATUS_503:int = 503; //Bad gateway
    public static const HTTP_STATUS_OK:int = 200;
    public static const HTTP_STATUS_NOT_MODIFIED:int = 304;
    public static const HTTP_ERROR_CODES:Vector.<int> = Vector.<int>([HTTP_STATUS_400, HTTP_STATUS_403, HTTP_STATUS_404, HTTP_STATUS_503, HTTP_STATUS_502, HTTP_STATUS_500]);

    public static function isInErrorCodes(statusCode:int):Boolean {
        return HTTP_ERROR_CODES.indexOf(statusCode) != -1;
    }
}
}
