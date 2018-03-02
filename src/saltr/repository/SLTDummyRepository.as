/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {
/**
 * The SLTDummyRepository class represents the dummy repository.
 */
public class SLTDummyRepository implements ISLTRepository {

    /**
     * Provides an object from storage.
     * @param name The name of the object.
     * @return The requested object.
     */
    public function getObjectFromStorage(name:String):Object {
        return null;
    }

    /**
     * Provides an object from cache.
     * @param fileName The name of the object.
     * @return The requested object.
     */
    public function getObjectFromCache(fileName:String):Object {
        return null;
    }

    /**
     * Stores an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    public function saveObject(name:String, object:Object):void {
    }

    /**
     * Caches an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    public function cacheObject(name:String, object:Object):void {
    }

    /**
     * Provides an object from application.
     * @param fileName The name of the object.
     * @return The requested object.
     */
    public function getObjectFromApplication(fileName:String):Object {
        return null;
    }

    /**
     *  Indicates whether the referenced file
     * @param fileName The name of the object.
     * @return true if file exist,false otherwise.
     */
    public function cachedFileExist(fileName:String):Boolean {
        return false;
    }

    /**
     *  Provides an array of File objects from cache
     * @param fileName The name of the object.
     * @param pattern The pattern to match, which can be any type of object but is typically either a string or a regular expression.
     * @return Returns an array of File objects. Array is filtered by pattern.
     */
    public function getCacheDirectoryListing(fileName:String, pattern:*=null):Array{
        return null;
    }
}
}
