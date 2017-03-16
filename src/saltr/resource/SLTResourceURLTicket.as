/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.resource {
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTResourceURLTicket class represents the URL ticket for resource.
 * @private
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
    private var _dropTimeout:Number;
    private var _progressiveTimeout:int;

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
        _idleTimeout = 3000.0;
        _userAgent = null;
        //
        _url = url;
        _method = URLRequestMethod.GET;
        _variables = variables;
        _requestHeaders = [];
        _checkPolicy = false;
        _maxAttempts = 3;
        _useSameDomain = true;
        _dropTimeout = 0.0;
        _progressiveTimeout = 0;
    }

    /**
     * Provides the URL request.
     * @return The URL request.
     */
    saltr_internal function getURLRequest():URLRequest {
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
    saltr_internal function addHeader(name:String, value:String):void {
        _requestHeaders.push(new URLRequestHeader(name, value));
    }

    /**
     * Provides the value of the request header.
     * @param name The name of the header.
     * @return The value of the header, <code>null</code> if there is no existing header with provided name.
     */
    saltr_internal function getHeaderValue(name:String):String {
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
    saltr_internal function get authenticate():Boolean {
        return _authenticate;
    }

    /**
     * @private
     */
    saltr_internal function set authenticate(value:Boolean):void {
        _authenticate = value;
    }

    /**
     * Response caching.
     */
    saltr_internal function get cacheResponse():Boolean {
        return _cacheResponse;
    }

    /**
     * @private
     */
    saltr_internal function set cacheResponse(value:Boolean):void {
        _cacheResponse = value;
    }

    /**
     * The type of content.
     */
    saltr_internal function get contentType():String {
        return _contentType;
    }

    /**
     * @private
     */
    saltr_internal function set contentType(value:String):void {
        _contentType = value;
    }

    /**
     * URL variables.
     */
    saltr_internal function get variables():Object {
        return _variables;
    }

    /**
     * @private
     */
    saltr_internal function set variables(value:Object):void {
        _variables = value;
    }

    /**
     * Follow redirects.
     */
    saltr_internal function get followRedirects():Boolean {
        return _followRedirects;
    }

    /**
     * @private
     */
    saltr_internal function set followRedirects(value:Boolean):void {
        _followRedirects = value;
    }

    /**
     * Idle timeout.
     */
    saltr_internal function get idleTimeout():Number {
        return _idleTimeout;
    }

    /**
     * @private
     */
    saltr_internal function set idleTimeout(value:Number):void {
        _idleTimeout = value;
    }

    /**
     * Manage cookies.
     */
    saltr_internal function get manageCookies():Boolean {
        return _manageCookies;
    }

    /**
     * @private
     */
    saltr_internal function set manageCookies(value:Boolean):void {
        _manageCookies = value;
    }

    /**
     * Method.
     */
    saltr_internal function get method():String {
        return _method;
    }

    /**
     * @private
     */
    saltr_internal function set method(value:String):void {
        _method = value;
    }

    /**
     * Request headers.
     */
    saltr_internal function get requestHeaders():Array {
        return _requestHeaders;
    }

    /**
     * @private
     */
    saltr_internal function set requestHeaders(value:Array):void {
        _requestHeaders = value;
    }

    /**
     * URL.
     */
    saltr_internal function get url():String {
        return _url;
    }

    /**
     * @private
     */
    saltr_internal function set url(value:String):void {
        _url = value;
    }

    /**
     * Use cache.
     */
    saltr_internal function get useCache():Boolean {
        return _useCache;
    }

    /**
     * @private
     */
    saltr_internal function set useCache(value:Boolean):void {
        _useCache = value;
    }

    /**
     * User agent.
     */
    saltr_internal function get userAgent():String {
        return _userAgent;
    }

    /**
     * @private
     */
    saltr_internal function set userAgent(value:String):void {
        _userAgent = value;
    }

    /**
     * Maximum attempts.
     */
    saltr_internal function get maxAttempts():int {
        return _maxAttempts;
    }

    /**
     * @private
     */
    saltr_internal function set maxAttempts(value:int):void {
        _maxAttempts = value;
    }

    /**
     * Policy checking.
     */
    saltr_internal function get checkPolicy():Boolean {
        return _checkPolicy;
    }

    /**
     * @private
     */
    saltr_internal function set checkPolicy(value:Boolean):void {
        _checkPolicy = value;
    }

    /**
     * Use same domain.
     */
    saltr_internal function get useSameDomain():Boolean {
        return _useSameDomain;
    }

    /**
     * @private
     */
    saltr_internal function set useSameDomain(value:Boolean):void {
        _useSameDomain = value;
    }

    /**
     * Dropping timeout.
     */
    saltr_internal function get dropTimeout():Number {
        return _dropTimeout;
    }

    /**
     * @private
     */
    saltr_internal function set dropTimeout(value:Number):void {
        _dropTimeout = value;
    }

    /**
     * @private
     */
    saltr_internal function get progressiveTimeout():int {
        return _progressiveTimeout;
    }

    /**
     * @private
     */
    saltr_internal function set progressiveTimeout(value:int):void {
        _progressiveTimeout = value;
    }
}
}