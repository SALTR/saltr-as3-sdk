/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

package saltr.resource {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequestHeader;
import flash.utils.Timer;

import saltr.utils.HTTPStatus;

public class SLTResource {

    protected var _id:String;
    protected var _isLoaded:Boolean;
    protected var _ticket:SLTResourceURLTicket;
    protected var _fails:int;
    protected var _maxAttempts:int;
    protected var _dropTimeout:int;
    protected var _httpStatus:int;
    protected var _timeoutTimer:Timer;
    protected var _responseHeaders:Vector.<URLRequestHeader>;
    protected var _urlLoader:URLLoader;
    protected var _onSuccess:Function;
    protected var _onFail:Function;
    protected var _onProgress:Function;

    /**
     *
     * @param id the id of asset
     * @param ticket ticket for loading the asset
     * @param onSuccess callback function if loading succeed, function signature is function(asset:Asset)
     * @param onFail callback function if loading fail, function signature is function(asset:Asset)
     * @param onProgress callback function for asset loading progress, function signature is function(bytesLoaded:int, bytesTotal:int, percentLoaded:int)
     */
    public function SLTResource(id:String, ticket:SLTResourceURLTicket, onSuccess:Function, onFail:Function, onProgress:Function = null) {
        //
        _id = id;
        _ticket = ticket;
        _onSuccess = onSuccess;
        _onFail = onFail;
        _onProgress = onProgress;
        _maxAttempts = _ticket.maxAttempts;
        _fails = 0;
        _dropTimeout = _ticket.dropTimeout;
        _httpStatus = -1;
        //
        initLoader();
    }

    public function get bytesLoaded():int {
        return _urlLoader.bytesLoaded;
    }

    public function get bytesTotal():int {
        return _urlLoader.bytesTotal;
    }

    public function get percentLoaded():int {
        return Math.round((bytesLoaded / bytesTotal) * 100);
    }

    public function get id():String {
        return _id;
    }

    public function get data():Object {
        return _urlLoader.data;
    }

    public function get jsonData():Object {
        var json:Object = null;
        try {
            json = JSON.parse(String(data));
        }
        catch (e:Error) {
            trace("[JSONAsset] JSON parsing Error. " + _ticket.variables + " \n  " + data);
        }
        return json;
    }

    public function get ticket():SLTResourceURLTicket {
        return _ticket;
    }

    public function get isLoaded():Boolean {
        return _isLoaded;
    }

    public function get responseHeaders():Vector.<URLRequestHeader> {
        return _responseHeaders;
    }

    public function load():void {
        ++_fails;
        initLoaderListeners(_urlLoader);
        _urlLoader.load(_ticket.getURLRequest());
        startDropTimeoutTimer();
    }

    public function stop():void {
        try {
            _urlLoader.close();
        } catch (e:Error) {
        }
    }

    public function dispose():void {
        _urlLoader = null;
        _onSuccess = null;
        _onFail = null;
        _onProgress = null;
    }

    protected function initLoader():void {
        _urlLoader = new URLLoader();
        _urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
        initLoaderListeners(_urlLoader);
    }

    protected function progressHandler(event:Event):void {
        _onProgress(bytesLoaded, bytesTotal, percentLoaded);
    }

    /////////////////////////////////////////////
    //Handling Dropout Timer
    protected function startDropTimeoutTimer():void {
        if (_dropTimeout != 0) {
            _timeoutTimer = new Timer(_dropTimeout, 1);
            _timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dropTimeOutTimerHandler);
            _timeoutTimer.start();
        }
    }

    protected function stopDropTimeoutTimer():void {
        if (_timeoutTimer == null) {
            return;
        }
        _timeoutTimer.stop();
        _timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, dropTimeOutTimerHandler);
        _timeoutTimer = null;
    }

    protected function dropTimeOutTimerHandler(event:TimerEvent):void {
        stopDropTimeoutTimer();
        _urlLoader.close();
        removeLoaderListeners(_urlLoader);
        trace("[Asset] Loading is too long, so it stopped by force.");
        _onFail(this);
    }

    /////////////////////////////////////////////

    protected function initLoaderListeners(dispatcher:EventDispatcher):void {
        dispatcher.addEventListener(Event.COMPLETE, completeHandler);
        if (_onProgress) {
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        }
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        if (HTTPStatusEvent.HTTP_RESPONSE_STATUS) {
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseStatusHandler);
        }
        dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
    }

    protected function removeLoaderListeners(dispatcher:EventDispatcher):void {
        dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
        dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        if (HTTPStatusEvent.HTTP_RESPONSE_STATUS) {
            dispatcher.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseStatusHandler);
        }
        dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
    }

    private function completeHandler(event:Event):void {
        stopDropTimeoutTimer();
        var dispatcher:EventDispatcher = event.target as EventDispatcher;
        removeLoaderListeners(dispatcher);
        if (HTTPStatus.isInErrorCodes(_httpStatus)) {
            _onFail(this);
            trace("[ERROR] Asset with path '" + _ticket.url + "' cannot be found.");
        }
        else {
            _isLoaded = true;
            _onSuccess(this);
        }
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        stopDropTimeoutTimer();
        var dispatcher:EventDispatcher = event.target as EventDispatcher;
        removeLoaderListeners(dispatcher);
        if (_fails == _maxAttempts) {
            _onFail(this);
        } else {
            load();
        }
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        stopDropTimeoutTimer();
        var dispatcher:EventDispatcher = event.target as EventDispatcher;
        removeLoaderListeners(dispatcher);
        _onFail(this);
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
        var dispatcher:EventDispatcher = event.target as EventDispatcher;
        dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        _httpStatus = event.status;
    }

    private function httpResponseStatusHandler(event:HTTPStatusEvent):void {
        var dispatcher:EventDispatcher = event.target as EventDispatcher;
        dispatcher.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseStatusHandler);
        _responseHeaders = Vector.<URLRequestHeader>(event.responseHeaders);
        _httpStatus = event.status;
    }
}
}
