/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.resource {
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;

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

    public function addHeader(name:String, value:String):void {
        _requestHeaders.push(new URLRequestHeader(name, value));
    }

    public function getHeaderValue(name:String):String {
        for each(var header:URLRequestHeader in _requestHeaders) {
            if (header.name == name) {
                return header.value;
            }
        }
        return null;
    }

    public function get authenticate():Boolean {
        return _authenticate;
    }

    public function set authenticate(value:Boolean):void {
        _authenticate = value;
    }

    public function get cacheResponse():Boolean {
        return _cacheResponse;
    }

    public function set cacheResponse(value:Boolean):void {
        _cacheResponse = value;
    }

    public function get contentType():String {
        return _contentType;
    }

    public function set contentType(value:String):void {
        _contentType = value;
    }

    public function get variables():Object {
        return _variables;
    }

    public function set variables(value:Object):void {
        _variables = value;
    }

    public function get followRedirects():Boolean {
        return _followRedirects;
    }

    public function set followRedirects(value:Boolean):void {
        _followRedirects = value;
    }

    public function get idleTimeout():Number {
        return _idleTimeout;
    }

    public function set idleTimeout(value:Number):void {
        _idleTimeout = value;
    }

    public function get manageCookies():Boolean {
        return _manageCookies;
    }

    public function set manageCookies(value:Boolean):void {
        _manageCookies = value;
    }

    public function get method():String {
        return _method;
    }

    public function set method(value:String):void {
        _method = value;
    }

    public function get requestHeaders():Array {
        return _requestHeaders;
    }

    public function set requestHeaders(value:Array):void {
        _requestHeaders = value;
    }

    public function get url():String {
        return _url;
    }

    public function set url(value:String):void {
        _url = value;
    }

    public function get useCache():Boolean {
        return _useCache;
    }

    public function set useCache(value:Boolean):void {
        _useCache = value;
    }

    public function get userAgent():String {
        return _userAgent;
    }

    public function set userAgent(value:String):void {
        _userAgent = value;
    }

    public function get maxAttempts():int {
        return _maxAttempts;
    }

    public function set maxAttempts(value:int):void {
        _maxAttempts = value;
    }

    public function get checkPolicy():Boolean {
        return _checkPolicy;
    }

    public function set checkPolicy(value:Boolean):void {
        _checkPolicy = value;
    }

    public function get useSameDomain():Boolean {
        return _useSameDomain;
    }

    public function set useSameDomain(value:Boolean):void {
        _useSameDomain = value;
    }

    public function get dropTimeout():int {
        return _dropTimeout;
    }

    public function set dropTimeout(value:int):void {
        _dropTimeout = value;
    }
}
}