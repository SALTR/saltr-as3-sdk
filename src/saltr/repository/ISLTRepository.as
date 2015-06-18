/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {

/**
 * The ISLTRepository class represents the interface for working with repository.
 */
public interface ISLTRepository {

    /**
     * Provides an object from storage.
     * @param name The name of the object.
     * @return The requested object.
     */
    function getObjectFromStorage(name:String):Object;

    /**
     * Provides an object from cache.
     * @param fileName The name of the object.
     * @return The requested object.
     */
    function getObjectFromCache(fileName:String):Object;

    /**
     * Provides the cached level version.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalId The global identifier of the cached level.
     * @return The version of the cached level.
     */
    function getCachedLevelVersion(gameLevelsFeatureToken:String, globalId:int):String;

    /**
     * Stores an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    function saveObject(name:String, object:Object):void;

    /**
     * Caches an object.
     * @param name The name of the object.
     * @param version The version of the object.
     * @param object The object to store.
     */
    function cacheObject(name:String, version:String, object:Object):void;

    /**
     * Provides an object from application.
     * @param fileName The name of the object.
     * @return The requested object.
     */
    function getObjectFromApplication(fileName:String):Object;

}
}
