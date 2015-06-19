/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {

/**
 * The ISLTRepository class represents the interface for working with repository.
 */
public interface ISLTRepository {

    /**
     * Defines the local content root.
     * @param contentRoot The content root url.
     */
    function setLocalContentRoot(contentRoot:String):void;

    /**
     * Provides an object from storage.
     * @param name The name of the object.
     * @return The requested object.
     */
    function getObjectFromStorage(name:String):Object;

    /**
     * Provides an level object from cache.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from cache.
     */
    function getLevelFromCache(gameLevelsFeatureToken:String, globalIndex:int):Object;

    /**
     * Provides the cached level version.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The version of the cached level.
     */
    function getLevelVersionFromCache(gameLevelsFeatureToken:String, globalIndex:int):String;

    /**
     * Stores an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    function saveObject(name:String, object:Object):void;

    /**
     * Caches an level content.
     * @param featureToken The "GameLevels" feature token the level belong to.
     * @param version The version of the level.
     * @param object The level to store.
     */
    function cacheLevelContent(featureToken:String, version:String, object:Object):void;

    /**
     * Caches an application data.
     * @param object The object to store.
     */
    function cacheAppData(object:Object):void;

    /**
     * Provides an level object from application.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from application.
     */
    function getLevelFromApplication(gameLevelsFeatureToken:String, globalIndex:int):Object;
}
}
