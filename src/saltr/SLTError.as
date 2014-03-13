/**
 * User: daal
 * Date: 3/13/14
 * Time: 12:23 PM
 */
package saltr {
public class SLTError {

    public static const AUTHORIZATION_ERROR_CODE: int = 1001;
    public static const VALIDATION_ERROR_CODE: int = 1002;
    public static const API_ERROR_CODE: int = 1003;
    public static const GENERAL_ERROR_CODE : int = 2001;
    public static const CLIENT_ERROR_CODE : int = 2002;

    private var _errorCode : int;
    private var _errorMessage : String;

    public function SLTError(code : int, message : String) {
        _errorCode = code;
        _errorMessage = message;
    }

    public function get errorMessage():String {
        return _errorMessage;
    }

    public function get errorCode():int {
        return _errorCode;
    }
}
}
