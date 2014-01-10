/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 12/1/12
 * Time: 5:23 PM
 */
package plexonic.saltr {

import flash.net.URLVariables;

import plexonic.asset.Asset;
import plexonic.asset.JSONAsset;
import plexonic.asset.URLTicket;

import starling.events.Event;

internal class SaltrAPI implements ISaltrAPI {

    public function SaltrAPI() {
    }

    public function addProperty(saltUserId:String, saltInstanceKey:String, propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = Saltr.COMMAND_ADDPROP;
        var args:Object = {saltId: saltUserId};
        var properties:Array = [];
        for (var i:uint = 0; i < propertyNames.length; i++) {
            var propertyName:String = propertyNames[i];
            var propertyValue:* = propertyValues[i];
            var operation:String = operations[i];
            properties.push({key: propertyName, value: propertyValue, operation: operation});
        }
        args.properties = properties;
        args.instanceKey = saltInstanceKey;
        urlVars.arguments = JSON.stringify(args);

        var ticket:URLTicket = new URLTicket(Saltr.SALT_API_URL, urlVars);

        var asset:JSONAsset = new JSONAsset("property", ticket);
        //
        //TODO @GSAR: get rid of nested functions!
        asset.addEventListener(Asset.EVENT_LOAD_COMPLETE, function (event:Event):void {
            trace("getSaltLevelPacks : success");
            event.target.removeEventListeners();
            var data:Object = asset.jsonData;
            asset.dispose();
        });
        //
        asset.addEventListener(Asset.EVENT_LOAD_ERROR, function (event:Event):void {
            trace("getSaltLevelPacks : error");
            event.target.removeEventListeners();
            asset.dispose();
        });
        //
        asset.load();
    }

    public function getSaltLevelPacks(partner:SaltrPartnerDTO, device:SaltrDeviceDTO, saltInstanceKey:String, platform:String, successHandler:Function, failureHandler:Function):void {

        var urlVars:URLVariables = new URLVariables();

        //TODO @GSAR: why not make a special a dynamic class to define "command" and "arguments" properties?
        urlVars.command = Saltr.COMMAND_EXPG;

        var args:Object = {};

        if (device != null) {
            args.device = device;
        }
        if (partner != null) {
            args.partner = partner;
        }
        args.instanceKey = saltInstanceKey;
        urlVars.arguments = JSON.stringify(args);

        var ticket:URLTicket = new URLTicket(Saltr.SALT_API_URL, urlVars);
        var asset:JSONAsset = new JSONAsset("level_pack", ticket);
        //

        //TODO @GSAR: get rid of nested functions!
        asset.addEventListener(Asset.EVENT_LOAD_COMPLETE, function (event:Event):void {
            trace("getSaltLevelPacks : success");
            event.target.removeEventListeners();
            var data:Object = asset.jsonData;
            successHandler(data);
            asset.dispose();
        });
        //
        asset.addEventListener(Asset.EVENT_LOAD_ERROR, function (event:Event):void {
            trace("getSaltLevelPacks : error");
            event.target.removeEventListeners();
            failureHandler();
            asset.dispose();
        });
        //
        asset.load();
    }

    public function loadAppData(partner:SaltrPartnerDTO, device:SaltrDeviceDTO, saltInstanceKey:String, platform:String, successHandler:Function, failureHandler:Function):void {
        var urlVars:URLVariables = new URLVariables();
        urlVars.command = Saltr.COMMAND_APPDATA;

        var args:Object = {};

        if (device != null) {
            args.device = device;
        }
        if (partner != null) {
            args.partner = partner;
        }
        args.instanceKey = saltInstanceKey;
        urlVars.arguments = JSON.stringify(args);


        var ticket:URLTicket = new URLTicket(Saltr.SALT_API_URL, urlVars);

        //TODO @GSAR: do we need this comment?
//        transport.idleTimeout = SaltClient.SALT_CALL_TIMEOUT;
        var asset:JSONAsset = new JSONAsset("saltAppConfig", ticket);
        //
        //TODO @GSAR: get rid of nested functions!
        asset.addEventListener(Asset.EVENT_LOAD_COMPLETE, function (event:Event):void {
            trace("[SaltAPI] App data is loaded.");
            event.target.removeEventListeners();
            var data:Object = asset.jsonData;
            successHandler(data);
            asset.dispose();
        });
        //
        asset.addEventListener(Asset.EVENT_LOAD_ERROR, function (event:Event):void {
            trace("[SaltAPI] App data is failed to load.");
            event.target.removeEventListeners();
            failureHandler();
            asset.dispose();
        });
        //
        asset.load();
    }
}
}
