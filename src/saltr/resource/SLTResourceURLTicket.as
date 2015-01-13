/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.resource {
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;

/**
 * The SLTResourceURLTicket class represents the URL ticket for resource.
 */
public class SLTResourceURLTicket {

    //URLRequest variables
    private var _authenticate:Boolean;
    private var _cacheResponse:Boolean;
    private var _contentType:String;
    private var _variables:Object;
    private var _followRedirects:Boolean;
    private var _idleTimeout:Number;
    private var _manageCookies:Boolean;
    private var _method:String;
    private var _requestHeaders:Array;
    private var _url:String;
    private var _useCache:Boolean;
    private var _userAgent:String;

    //Transport specific variables
    private var _checkPolicy:Boolean;
    private var _useSameDomain:Boolean;
    private var _maxAttempts:int;
    private var _dropTimeout:int;


    /**
     * Class constructor.
     * @param url The URL.
     * @param variables The URL variables.
     */
    public function SLTResourceURLTicket(url:String, variables:Object = null) {
        _authenticate = true;
        _cacheResponse = true;
        _followRedirects = true;
        _manageCookies = true;
        _useCache = true;
        //
        _idleTimeout = 3000;
        _userAgent = null;
        //
        _url = url;
        _method = URLRequestMethod.GET;
        _variables = variables;
        _requestHeaders = [];
        _checkPolicy = false;
        _maxAttempts = 3;
        _useSameDomain = true;
        _dropTimeout = 0;
    }

    /**
     * Provides the URL request.
     * @return The URL request.
     */
    public function getURLRequest():URLRequest {
        var request:URLRequest = new URLRequest(_url);
        if (request.hasOwnProperty("authenticate")) {
            request["authenticate"] = _authenticate;
            request["cacheResponse"] = _cacheResponse;
            //
            if (_idleTimeout != 0) {
                request["idleTimeout"] = _idleTimeout;
            }
            //
            request["manageCookies"] = _manageCookies;
            request["useCache"] = _useCache;
            request["followRedirects"] = _followRedirects;
            //
            if (_userAgent != null) {
                request["userAgent"] = _userAgent;
            }

        }

        request.url = _url;
        request.data = _variables;
        request.method = _method;
        request.contentType = _contentType;
        for each(var header:URLRequestHeader in _requestHeaders) {
            request.requestHeaders.push(header);
        }
        return request;
    }

    /**
     * Adds request header.
     * @param name The name of the header.
     * @param value The value of the header.
     */
    public function addHeader(name:String, value:String):void {
        _requestHeaders.push(new URLRequestHeader(name, value));
    }

    /**
     * Provides the value of the request header.
     * @param name The name of the header.
     * @return The value of the header, <code>null</code> if there is no existing header with provided name.
     */
    public function getHeaderValue(name:String):String {
        for each(var header:URLRequestHeader in _requestHeaders) {
            if (header.name == name) {
                return header.value;
            }
        }
        return null;
    }

    /**
     * Authentication.
     */
    public function get authenticate():Boolean {
        return _authenticate;
    }

    /**
     * @private
     */
    public function set authenticate(value:Boolean):void {
        _authenticate = value;
    }

    /**
     * Response caching.
     */
    public function get cacheResponse():Boolean {
        return _cacheResponse;
    }

    /**
     * @private
     */
    public function set cacheResponse(value:Boolean):void {
        _cacheResponse = value;
    }

    /**
     * The type of content.
     */
    public function get contentType():String {
        return _contentType;
    }

    /**
     * @private
     */
    public function set contentType(value:String):void {
        _contentType = value;
    }

    /**
     * URL variables.
     */
    public function get variables():Object {
        return _variables;
    }

    /**
     * @private
     */
    public function set variables(value:Object):void {
        _variables = value;
    }

    /**
     * Follow redirects.
     */
    public function get followRedirects():Boolean {
        return _followRedirects;
    }

    /**
     * @private
     */
    public function set followRedirects(value:Boolean):void {
        _followRedirects = value;
    }

    /**
     * Idle timeout.
     */
    public function get idleTimeout():Number {
        return _idleTimeout;
    }

    /**
     * @private
     */
    public function set idleTimeout(value:Number):void {
        _idleTimeout = value;
    }

    /**
     * Manage cookies.
     */
    public function get manageCookies():Boolean {
        return _manageCookies;
    }

    /**
     * @private
     */
    public function set manageCookies(value:Boolean):void {
        _manageCookies = value;
    }

    /**
     * Method.
     */
    public function get method():String {
        return _method;
    }

    /**
     * @private
     */
    public function set method(value:String):void {
        _method = value;
    }

    /**
     * Request headers.
     */
    public function get requestHeaders():Array {
        return _requestHeaders;
    }

    /**
     * @private
     */
    public function set requestHeaders(value:Array):void {
        _requestHeaders = value;
    }

    /**
     * URL.
     */
    public function get url():String {
        return _url;
    }

    /**
     * @private
     */
    public function set url(value:String):void {
        _url = value;
    }

    /**
     * Use cache.
     */
    public function get useCache():Boolean {
        return _useCache;
    }

    /**
     * @private
     */
    public function set useCache(value:Boolean):void {
        _useCache = value;
    }

    /**
     * User agent.
     */
    public function get userAgent():String {
        return _userAgent;
    }

    /**
     * @private
     */
    public function set userAgent(value:String):void {
        _userAgent = value;
    }

    /**
     * Maximum attempts.
     */
    public function get maxAttempts():int {
        return _maxAttempts;
    }

    /**
     * @private
     */
    public function set maxAttempts(value:int):void {
        _maxAttempts = value;
    }

    /**
     * Policy checking.
     */
    public function get checkPolicy():Boolean {
        return _checkPolicy;
    }

    /**
     * @private
     */
    public function set checkPolicy(value:Boolean):void {
        _checkPolicy = value;
    }

    /**
     * Use same domain.
     */
    public function get useSameDomain():Boolean {
        return _useSameDomain;
    }

    /**
     * @private
     */
    public function set useSameDomain(value:Boolean):void {
        _useSameDomain = value;
    }

    /**
     * Dropping timeout.
     */
    public function get dropTimeout():int {
        return _dropTimeout;
    }

    /**
     * @private
     */
    public function set dropTimeout(value:int):void {
        _dropTimeout = value;
    }
}
}