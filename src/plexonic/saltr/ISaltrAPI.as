/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 12/1/12
 * Time: 5:11 PM
 */
package plexonic.saltr {

public interface ISaltrAPI {

    function getSaltLevelPacks(partner:SaltrPartnerDTO, device:SaltrDeviceDTO, saltInstanceKey:String, platform:String, successHandler:Function, failureHandler:Function):void;

    function loadAppData(partner:SaltrPartnerDTO, device:SaltrDeviceDTO, saltInstanceKey:String, platform:String, successHandler:Function, failureHandler:Function):void;

    function addProperty(saltUserId:String, saltInstanceKey:String, propertyNames:Vector.<String>, propertyValues:Vector.<*>, operations:Vector.<String>):void;
}
}
