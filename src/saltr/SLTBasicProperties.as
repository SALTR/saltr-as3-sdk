/**
 * Created by GSAR on 6/10/14.
 */
package saltr {

/**
 * The SLTBasicProperties class represents the basic user properties.
 * This information is useful for analytics and statistics.
 */
public dynamic class SLTBasicProperties extends Object {
    private var _age:String;
    private var _gender:String;         //Gender "F", "M", "female", "male"

    private var _appVersion:String;     // Version of the client app, e.g. 4.1.1

    private var _systemName:String;     //The name of the OS the current device is running. E.g. iPhone OS.
    private var _systemVersion:String;  //The version number of the OS the current device is running. E.g. 6.0.

    private var _browserName:String;    //The name of the browser the current device is running. E.g. Chrome.
    private var _browserVersion:String; //The version number of the browser the current device is running. E.g. 17.0.

    private var _deviceName:String;     //A human-readable name representing the device.
    private var _deviceType:String;     //The Type name of the device. E.g. iPad.

    private var _locale:String;         //The current locale the user is in. E.g. en_US.

    private var _country:String;        //The country the user is in, specified by ISO 2-letter code. E.g. US for United States.
                                        //Set to (locate) to detect the country based on the IP address of the caller.

    private var _region:String;         //The region (state) the user is in. E.g. ca for California.
                                        //Set to (locate) to detect the region based on the IP address of the caller.

    private var _city:String;           //The city the user is in. E.g. San Francisco.
                                        //Set to (locate) to detect the city based on the IP address of the caller.

    private var _location:String;       //The location (latitude/longitude) of the user. E.g. 37.775,-122.4183.
                                        //Set to (locate) to detect the location based on the IP address of the caller.

    public function SLTBasicProperties() {
    }

    /**
     * The age of the user.
     */
    public function get age():String {
        return _age;
    }

    /**
     * @private
     */
    public function set age(value:String):void {
        _age = value;
    }

    /**
     * The gender information of the user.
     * Possible values are "f" (female) and "m" (male)
     */
    public function get gender():String {
        return _gender;
    }

    /**
     * @private
     */
    public function set gender(value:String):void {
        _gender = value;
    }

    /**
     * The name of the OS the current device is running. E.g. iPhone OS.
     */
    public function get systemName():String {
        return _systemName;
    }

    /**
     * @private
     */
    public function set systemName(value:String):void {
        _systemName = value;
    }

    /**
     * The version number of the OS the current device is running. E.g. 6.0.
     */
    public function get systemVersion():String {
        return _systemVersion;
    }

    /**
     * @private
     */
    public function set systemVersion(value:String):void {
        _systemVersion = value;
    }

    /**
     * The name of the browser the current device is running. E.g. Chrome.
     */
    public function get browserName():String {
        return _browserName;
    }

    /**
     * @private
     */
    public function set browserName(value:String):void {
        _browserName = value;
    }

    /**
     * The version number of the browser the current device is running. E.g. 17.0.
     */
    public function get browserVersion():String {
        return _browserVersion;
    }

    /**
     * @private
     */
    public function set browserVersion(value:String):void {
        _browserVersion = value;
    }

    /**
     * A human-readable name representing the device.
     */
    public function get deviceName():String {
        return _deviceName;
    }

    /**
     * @private
     */
    public function set deviceName(value:String):void {
        _deviceName = value;
    }

    /**
     * The Type name of the device. E.g. iPad.
     */
    public function get deviceType():String {
        return _deviceType;
    }

    /**
     * @private
     */
    public function set deviceType(value:String):void {
        _deviceType = value;
    }

    /**
     * The current locale the user is in. E.g. en_US.
     */
    public function get locale():String {
        return _locale;
    }

    /**
     * @private
     */
    public function set locale(value:String):void {
        _locale = value;
    }

    /**
     * The country the user is in, specified by ISO 2-letter code. E.g. US for United States.
     * Set to (locate) to detect the country based on the IP address of the caller.
     */
    public function get country():String {
        return _country;
    }

    /**
     * @private
     */
    public function set country(value:String):void {
        _country = value;
    }

    /**
     * The region (state) the user is in. E.g. ca for California.
     * Set to (locate) to detect the region based on the IP address of the caller.
     */
    public function get region():String {
        return _region;
    }

    /**
     * @private
     */
    public function set region(value:String):void {
        _region = value;
    }

    /**
     * The city the user is in. E.g. San Francisco.
     * Set to (locate) to detect the city based on the IP address of the caller.
     */
    public function get city():String {
        return _city;
    }

    /**
     * @private
     */
    public function set city(value:String):void {
        _city = value;
    }

    /**
     * The location (latitude/longitude) of the user. E.g. 37.775,-122.4183.
     * Set to (locate) to detect the location based on the IP address of the caller.
     */
    public function get location():String {
        return _location;
    }

    /**
     * @private
     */
    public function set location(value:String):void {
        _location = value;
    }

    /**
     * Version of the client app, e.g. 4.1.1
     */
    public function get appVersion():String {
        return _appVersion;
    }

    /**
     * @private
     */
    public function set appVersion(value:String):void {
        _appVersion = value;
    }
}
}
