/**
 * Created by GSAR on 6/10/14.
 */
package saltr {
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

    public function get age():String {
        return _age;
    }

    public function set age(value:String):void {
        _age = value;
    }

    public function get gender():String {
        return _gender;
    }

    public function set gender(value:String):void {
        _gender = value;
    }

    public function get systemName():String {
        return _systemName;
    }

    public function set systemName(value:String):void {
        _systemName = value;
    }

    public function get systemVersion():String {
        return _systemVersion;
    }

    public function set systemVersion(value:String):void {
        _systemVersion = value;
    }

    public function get browserName():String {
        return _browserName;
    }

    public function set browserName(value:String):void {
        _browserName = value;
    }

    public function get browserVersion():String {
        return _browserVersion;
    }

    public function set browserVersion(value:String):void {
        _browserVersion = value;
    }

    public function get deviceName():String {
        return _deviceName;
    }

    public function set deviceName(value:String):void {
        _deviceName = value;
    }

    public function get deviceType():String {
        return _deviceType;
    }

    public function set deviceType(value:String):void {
        _deviceType = value;
    }

    public function get locale():String {
        return _locale;
    }

    public function set locale(value:String):void {
        _locale = value;
    }

    public function get country():String {
        return _country;
    }

    public function set country(value:String):void {
        _country = value;
    }

    public function get region():String {
        return _region;
    }

    public function set region(value:String):void {
        _region = value;
    }

    public function get city():String {
        return _city;
    }

    public function set city(value:String):void {
        _city = value;
    }

    public function get location():String {
        return _location;
    }

    public function set location(value:String):void {
        _location = value;
    }

    public function get appVersion():String {
        return _appVersion;
    }

    public function set appVersion(value:String):void {
        _appVersion = value;
    }
}
}
