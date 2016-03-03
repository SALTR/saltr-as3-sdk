/**
 * Created by GSAR on 6/10/14.
 */
package saltr {
/**
 * The SLTBasicProperties class represents the basic user properties.
 * This information is useful for analytics and statistics.
 */
public dynamic class SLTBasicProperties extends Object {

    private var _data:Object = {};
    private const ageKey:String = "age";
    private const genderKey:String = "gender";         //Gender "F", "M", "female", "male"

    private const appVersionKey:String = "appVersion";     // Version of the client app, e.g. 4.1.1

    private const systemNameKey:String = "systemName";     //The name of the OS the current device is running. E.g. iPhone OS.
    private const systemVersionKey:String = "systemVersion";  //The version number of the OS the current device is running. E.g. 6.0.

    private const browserNameKey:String = "browserName";    //The name of the browser the current device is running. E.g. Chrome.
    private const browserVersionKey:String = "browserVersion"; //The version number of the browser the current device is running. E.g. 17.0.

    private const deviceNameKey:String = "deviceName";     //A human-readable name representing the device.
    private const deviceTypeKey:String = "deviceType";     //The Type name of the device. E.g. iPad.

    private const localeKey:String = "locale";         //The current locale the user is in. E.g. en_US.

    private const countryKey:String = "country";        //The country the user is in, specified by ISO 2-letter code. E.g. US for United States.
                                                        //Set to (locate) to detect the country based on the IP address of the caller.

    private const regionKey:String = "region";         //The region (state) the user is in. E.g. ca for California.
                                                       //Set to (locate) to detect the region based on the IP address of the caller.

    private const cityKey:String = "city";           //The city the user is in. E.g. San Francisco.
                                                    //Set to (locate) to detect the city based on the IP address of the caller.

    private const locationKey:String = "location";       //The location (latitude/longitude) of the user. E.g. 37.775,-122.4183.
                                                        //Set to (locate) to detect the location based on the IP address of the caller.

    /**
     * Class constructor.
     */
    public function SLTBasicProperties() {
    }

    saltr_internal function get data():Object {
        return _data;
    }

    /**
     * The age of the user.
     */
    public function get age():String {
        return _data[ageKey];
    }

    /**
     * @private
     */
    public function set age(value:String):void {
        _data[ageKey] = value;
    }

    /**
     * The gender information of the user.
     * Possible values are "f" (female) and "m" (male)
     */
    public function get gender():String {
        return _data[genderKey];
    }

    /**
     * @private
     */
    public function set gender(value:String):void {
        _data[genderKey] = value;
    }

    /**
     * The name of the OS the current device is running. E.g. iPhone OS.
     */
    public function get systemName():String {
        return _data[systemNameKey];
    }

    /**
     * @private
     */
    public function set systemName(value:String):void {
        _data[systemNameKey] = value;
    }

    /**
     * The version number of the OS the current device is running. E.g. 6.0.
     */
    public function get systemVersion():String {
        return _data[systemVersionKey];
    }

    /**
     * @private
     */
    public function set systemVersion(value:String):void {
        _data[systemVersionKey] = value;
    }

    /**
     * The name of the browser the current device is running. E.g. Chrome.
     */
    public function get browserName():String {
        return _data[browserNameKey];
    }

    /**
     * @private
     */
    public function set browserName(value:String):void {
        _data[browserNameKey] = value;
    }

    /**
     * The version number of the browser the current device is running. E.g. 17.0.
     */
    public function get browserVersion():String {
        return _data[browserVersionKey];
    }

    /**
     * @private
     */
    public function set browserVersion(value:String):void {
        _data[browserVersionKey] = value;
    }

    /**
     * A human-readable name representing the device.
     */
    public function get deviceName():String {
        return _data[deviceNameKey];
    }

    /**
     * @private
     */
    public function set deviceName(value:String):void {
        _data[deviceNameKey] = value;
    }

    /**
     * The Type name of the device. E.g. iPad.
     */
    public function get deviceType():String {
        return _data[deviceTypeKey];
    }

    /**
     * @private
     */
    public function set deviceType(value:String):void {
        _data[deviceTypeKey] = value;
    }

    /**
     * The current locale the user is in. E.g. en_US.
     */
    public function get locale():String {
        return _data[localeKey];
    }

    /**
     * @private
     */
    public function set locale(value:String):void {
        _data[localeKey] = value;
    }

    /**
     * The country the user is in, specified by ISO 2-letter code. E.g. US for United States.
     * Set to (locate) to detect the country based on the IP address of the caller.
     */
    public function get country():String {
        return _data[countryKey];
    }

    /**
     * @private
     */
    public function set country(value:String):void {
        _data[countryKey] = value;
    }

    /**
     * The region (state) the user is in. E.g. ca for California.
     * Set to (locate) to detect the region based on the IP address of the caller.
     */
    public function get region():String {
        return _data[regionKey];
    }

    /**
     * @private
     */
    public function set region(value:String):void {
        _data[regionKey] = value;
    }

    /**
     * The city the user is in. E.g. San Francisco.
     * Set to (locate) to detect the city based on the IP address of the caller.
     */
    public function get city():String {
        return _data[cityKey];
    }

    /**
     * @private
     */
    public function set city(value:String):void {
        _data[cityKey] = value;
    }

    /**
     * The location (latitude/longitude) of the user. E.g. 37.775,-122.4183.
     * Set to (locate) to detect the location based on the IP address of the caller.
     */
    public function get location():String {
        return _data[locationKey];
    }

    /**
     * @private
     */
    public function set location(value:String):void {
        _data[locationKey] = value;
    }

    /**
     * Version of the client app, e.g. 4.1.1
     */
    public function get appVersion():String {
        return _data[appVersionKey];
    }

    /**
     * @private
     */
    public function set appVersion(value:String):void {
        _data[appVersionKey] = value;
    }
}
}
