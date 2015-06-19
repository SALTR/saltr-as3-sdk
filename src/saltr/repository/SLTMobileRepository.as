/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import saltr.SLTConfig;
import saltr.SLTDeserializer;
import saltr.saltr_internal;
import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
 * The SLTMobileRepository class represents the mobile repository.
 */
public class SLTMobileRepository implements ISLTRepository {

    private var _storageDirectory:File;
    private var _applicationDirectory:File;
    private var _cacheDirectory:File;
    private var _fileStream:FileStream;
    private var _localContentRoot:String;

    private static function getCachedAppDataUrl():String {
        return SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_APP_DATA_URL_TEMPLATE, SLTUtils.getAppVersion());
    }

    saltr_internal static function getLevelDataFromApplicationUrl(contentRoot:String, token:String):String {
        return SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_DATA_URL_TEMPLATE, contentRoot, SLTUtils.getAppVersion(), token);
    }

    saltr_internal static function getCachedLevelVersionsUrl(gameLevelsFeatureToken:String):String {
        return SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_LEVEL_VERSIONS_URL_TEMPLATE, SLTUtils.getAppVersion(), gameLevelsFeatureToken);
    }

    /**
     * Class constructor.
     */
    public function SLTMobileRepository() {
        _applicationDirectory = File.applicationDirectory;
        _storageDirectory = File.applicationStorageDirectory;
        _cacheDirectory = File.cacheDirectory;
        _fileStream = new FileStream();
        _localContentRoot = SLTConfig.DEFAULT_CONTENT_ROOT;

//        trace("storageDirectory: " + _storageDirectory.nativePath);
//        trace("cacheDir: " + _cacheDirectory.nativePath);
    }

    /**
     * Defines the local content root.
     * @param contentRoot The content root url.
     */
    public function setLocalContentRoot(contentRoot:String):void {
        _localContentRoot = contentRoot;
    }

    /**
     * Provides an object from storage.
     * @param name The name of the object.
     * @return The requested object.
     */
    public function getObjectFromStorage(fileName:String):Object {
        var file:File = _storageDirectory.resolvePath(fileName);
        return getInternal(file);
    }

    /**
     * Provides an level object from application.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from application.
     */
    public function getLevelFromApplication(gameLevelsFeatureToken:String, globalIndex:int):Object {
        var fileName:String = SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_URL_TEMPLATE, _localContentRoot, SLTUtils.getAppVersion(), gameLevelsFeatureToken, globalIndex);
        return getObjectFromApplication(fileName);
    }

    /**
     * Provides an level object from cache.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from cache.
     */
    public function getLevelFromCache(gameLevelsFeatureToken:String, globalIndex:int):Object {
        var cachedLevelFileName:String = SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_LEVEL_URL_TEMPLATE, SLTUtils.getAppVersion(), gameLevelsFeatureToken, globalIndex);
        return getObjectFromCache(cachedLevelFileName);
    }

    /**
     * Provides the cached level version.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The version of the cached level.
     */
    public function getLevelVersionFromCache(gameLevelsFeatureToken:String, globalIndex:int):String {
        var version:String = null;
        var cachedLevelFileName:String = SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_LEVEL_URL_TEMPLATE, SLTUtils.getAppVersion(), gameLevelsFeatureToken, globalIndex);
        var cachedLevelFile:File = _cacheDirectory.resolvePath(cachedLevelFileName);
        if (cachedLevelFile.exists) {
            var cachedLevelVersions:Object = getObjectFromCache(getCachedLevelVersionsUrl(gameLevelsFeatureToken));
            if (null != cachedLevelVersions) {
                version = SLTDeserializer.getCachedLevelVersion(cachedLevelVersions, globalIndex);
            }
        }
        return version;
//        var file:File = _cacheDirectory.resolvePath(name.replace(".", "") + "_VERSION_");
//        var obj:Object = getInternal(file);
//        if (obj == null) {
//            return null;
//        }
//        return obj["_VERSION_"];
    }

//    /**
//     * Caches an object.
//     * @param name The name of the object.
//     * @param version The version of the object.
//     * @param object The object to store.
//     */
//    public function cacheObject(fileName:String, version:String, object:Object):void {
//        var file:File = _cacheDirectory.resolvePath(fileName);
//        saveInternal(file, object);
//        file = _cacheDirectory.resolvePath(fileName.replace(".", "") + "_VERSION_");
//        saveInternal(file, {_VERSION_: version});
//    }

    /**
     * Caches an level content.
     * @param featureToken The "GameLevels" feature token the level belong to.
     * @param version The version of the level.
     * @param object The level to store.
     */
    public function cacheLevelContent(featureToken:String, version:String, object:Object):void {
        //
    }

    /**
     * Caches an application data.
     * @param object The object to store.
     */
    public function cacheAppData(object:Object):void {
        var file:File = _cacheDirectory.resolvePath(getCachedAppDataUrl());
        saveInternal(file, object);
    }

    /**
     * Stores an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    public function saveObject(fileName:String, objectToSave:Object):void {
        var file:File = _storageDirectory.resolvePath(fileName);
        saveInternal(file, objectToSave);
    }

    private function getInternal(file:File):Object {
        try {
            if (!file.exists) {
                return null;
            }
            _fileStream.open(file, FileMode.READ);
            var stringData:String = _fileStream.readUTFBytes(_fileStream.bytesAvailable);
            _fileStream.close();
            return stringData ? JSON.parse(stringData) : null;
        }
        catch (error:Error) {
            trace("[MobileStorageEngine] : error while getting object.\nError : [ID : '" + error.errorID + "', message : '" + error.message + "'");
        }
        return null;
    }

    private function saveInternal(file:File, objectToSave:Object):void {
        try {
            _fileStream.open(file, FileMode.WRITE);
            _fileStream.writeUTFBytes(JSON.stringify(objectToSave));
            _fileStream.close();
        }
        catch (error:Error) {
            trace("[MobileStorageEngine] : error while saving object.\nError : [ID : '" + error.errorID + "', message : '" + error.message + "'");
        }
    }

    private function getObjectFromCache(fileName:String):Object {
        var file:File = _cacheDirectory.resolvePath(fileName);
        return getInternal(file);

    }

    private function getObjectFromApplication(fileName:String):Object {
        var file:File = _applicationDirectory.resolvePath(fileName);
        return getInternal(file);
    }
}
}
