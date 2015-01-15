/*
 * Copyright (c) 2014 Plexonic Ltd
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
import flash.utils.Timer;
import saltr.saltr_internal;

use namespace saltr_internal;

import saltr.utils.HTTPStatus;

/**
 * The SLTResource class represents the resource.
 */
//TODO @GSAR: review optimize this class!
public class SLTResource {

    private var _id:String;
    private var _isLoaded:Boolean;
    private var _ticket:SLTResourceURLTicket;
    private var _fails:int;
    private var _maxAttempts:int;
    private var _dropTimeout:int;
    private var _httpStatus:int;
    private var _timeoutTimer:Timer;
    private var _urlLoader:URLLoader;
    private var _onSuccess:Function;
    private var _onFail:Function;
    private var _onProgress:Function;

     /**
     * Class constructor.
     * @param id The id of asset.
     * @param ticket The ticket for loading the asset.
     * @param onSuccess The callback function if loading succeed, function signature is function(asset:Asset).
     * @param onFail The callback function if loading fail, function signature is function(asset:Asset).
     * @param onProgress The callback function for asset loading progress, function signature is function(bytesLoaded:int, bytesTotal:int, percentLoaded:int).
     */
    public function SLTResource(id:String, ticket:SLTResourceURLTicket, onSuccess:Function, onFail:Function, onProgress:Function = null) {
        _id = id;
        _ticket = ticket;
        _onSuccess = onSuccess;
        _onFail = onFail;
        _onProgress = onProgress;
        _maxAttempts = _ticket.maxAttempts;
        _fails = 0;
        _dropTimeout = _ticket.dropTimeout;
        _httpStatus = -1;
        initLoader();
    }

    /**
     * The loaded bytes.
     */
    public function get bytesLoaded():int {
        return _urlLoader.bytesLoaded;
    }

    /**
     * The total bytes.
     */
    public function get bytesTotal():int {
        return _urlLoader.bytesTotal;
    }

    /**
     * The loaded percent.
     */
    public function get percentLoaded():int {
        return Math.round((bytesLoaded / bytesTotal) * 100);
    }

    /**
     * The JSON data.
     */
    public function get jsonData():Object {
        var json:Object = null;
        try {
            json = JSON.parse(String(_urlLoader.data));
        }
        catch (e:Error) {
            trace("[JSONAsset] JSON parsing Error. " + _ticket.variables + " \n  " + _urlLoader.data);
        }
        return json;
    }

    /**
     * Starts load.
     */
    public function load():void {
        ++_fails;
        initLoaderListeners(_urlLoader);
        _urlLoader.load(_ticket.getURLRequest());
        startDropTimeoutTimer();
    }

    /**
     * Stops load.
     */
    public function stop():void {
        try {
            _urlLoader.close();
        } catch (e:Error) {
        }
    }

    /**
     * Dispose function.
     */
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
        if (HTTPStatus.isInSuccessCodes(_httpStatus)) {
            _isLoaded = true;
            _onSuccess(this);
        }
        else {
            _onFail(this);
            trace("[ERROR] Asset with path '" + _ticket.url + "' cannot be found.");
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
        _httpStatus = event.status;
    }
}
}
