/*
 * Copyright (c) 2014 Plexonic Ltd
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
