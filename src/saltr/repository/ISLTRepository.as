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
     * Stores an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    function saveObject(name:String, object:Object):void;

    /**
     * Caches an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    function cacheObject(name:String, object:Object):void;

    /**
     * Provides an object from application.
     * @param fileName The name of the object.
     * @return The requested object.
     */
    function getObjectFromApplication(fileName:String):Object;

    /**
     *  Indicates whether the referenced file
     * @param fileName The name of the object.
     * @return true if file exist,false otherwise.
     */
    function cachedFileExist(fileName:String):Boolean ;

    /**
     *  Provides an array of File objects from cache
     * @param fileName The name of the object.
     * @param pattern The pattern to match, which can be any type of object but is typically either a string or a regular expression.
     * @return Returns an array of File objects. Array is filtered by pattern.
     */
    function getCacheDirectoryListing(fileName:String, pattern:* = null):Array;
}
}
