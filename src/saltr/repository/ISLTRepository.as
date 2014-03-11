/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: gsar
 * Date: 4/1/13
 * Time: 9:13 PM
 */
package saltr.repository {
public interface ISLTRepository {

    function getObjectFromStorage(name:String):Object;

    function getObjectFromCache(fileName:String):Object;

    function getObjectVersion(name:String):String;

    function saveObject(name:String, object:Object):void;

    function cacheObject(name:String, version:String, object:Object):void;

    function getObjectFromApplication(fileName:String):Object;

}
}
