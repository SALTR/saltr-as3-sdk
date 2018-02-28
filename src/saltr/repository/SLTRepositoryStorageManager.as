/**
 * Created by daal on 6/24/15.
 */
package saltr.repository {
import flash.desktop.NativeApplication;
import flash.filesystem.File;

import saltr.SLTConfig;
import saltr.SLTDeserializer;
import saltr.saltr_internal;
import saltr.utils.SLTLogger;
import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTRepositoryStorageManager {

    private var _repository:ISLTRepository;
    private var _localContentRoot:String;

    private static function getAppVersion():String {
        var applicationDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
        var ns:Namespace = applicationDescriptor.namespace();
        return applicationDescriptor.ns::versionNumber[0].toString();
    }

    private static function getCachedAppDataUrl():String {
        return SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_APP_DATA_URL_TEMPLATE, getAppVersion());
    }

    private static function getAppDataFromApplicationUrl():String {
        return SLTUtils.formatString(SLTConfig.LOCAL_APP_DATA_URL_TEMPLATE);
    }

    private static function getLevelDataFromApplicationUrl(contentRoot:String, token:String):String {
        return SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_DATA_URL_TEMPLATE, contentRoot, token);
    }

    private static function getCachedLevelVersionsUrl(gameLevelsFeatureToken:String):String {
        return SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_LEVEL_VERSIONS_URL_TEMPLATE, getAppVersion(), gameLevelsFeatureToken);
    }

    private static function getCachedLevelUrl(gameLevelsFeatureToken:String, globalIndex:int):String {
        return SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_LEVEL_URL_TEMPLATE, getAppVersion(), gameLevelsFeatureToken, globalIndex);
    }

    private static function isCurrentAppVersionCacheDirExists(cacheDirectory:File):Boolean {
        var dir:File = cacheDirectory.resolvePath(SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_CONTENT_ROOT_URL_TEMPLATE, getAppVersion()));
        return dir.exists;
    }

    private static function cleanupCache(cacheDirectory:File):void {
        var rootDir:File = cacheDirectory.resolvePath(SLTConfig.DEFAULT_CONTENT_ROOT);
        if (rootDir.exists) {
            var contents:Array = rootDir.getDirectoryListing();
            var currentAppCacheName:String = "app_" + getAppVersion();
            for (var i:uint = 0, length:uint = contents.length; i < length; i++) {
                var contentName:String = contents[i].name;
                if (currentAppCacheName != contentName && 0 == contentName.indexOf("app_")) {
                    var dir:File = rootDir.resolvePath(contents[i].name);
                    if (dir.isDirectory) {
                        dir.deleteDirectory(true);
                    }
                }
            }
        }
    }

    public function SLTRepositoryStorageManager(repository:ISLTRepository) {
        _repository = repository;
        _localContentRoot = SLTConfig.DEFAULT_CONTENT_ROOT;
    }

    /**
     * Defines the local content root.
     * @param contentRoot The content root url.
     */
    saltr_internal function setLocalContentRoot(contentRoot:String):void {
        _localContentRoot = contentRoot;
    }

    /**
     * Provides an object from storage.
     * @param name The name of the object.
     * @return The requested object.
     */
    saltr_internal function getObjectFromStorage(fileName:String):Object {
        return _repository.getObjectFromStorage(fileName);
    }

    /**
     * Provides the cached application data.
     * @return The cached application data.
     */
    saltr_internal function getAppDataFromCache():Object {
        return _repository.getObjectFromCache(getCachedAppDataUrl());
    }


    /**
     * Provides the application data wrapped in package.
     * @return The wrapped in package application data.
     */
    saltr_internal function getAppDataFromApplication():Object {
        return _repository.getObjectFromApplication(getAppDataFromApplicationUrl());
    }

    /**
     * Provides an level object from cache.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from cache.
     */
    saltr_internal function getLevelFromCache(gameLevelsFeatureToken:String, globalIndex:int):Object {
        return _repository.getObjectFromCache(getCachedLevelUrl(gameLevelsFeatureToken, globalIndex));
    }

    /**
     * Provides the cached level version.
     * @param cachedLevelVersions The level versioning file from cache.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The version of the cached level.
     */
    saltr_internal function getLevelVersionFromCache(cachedLevelVersions:Object, gameLevelsFeatureToken:String, globalIndex:int):String {
        var version:String = null;
        var cachedLevelFile:Object = _repository.getObjectFromCache(getCachedLevelUrl(gameLevelsFeatureToken, globalIndex));
        if (cachedLevelFile != null && cachedLevelVersions != null) {
            version = SLTDeserializer.getCachedLevelVersion(cachedLevelVersions, globalIndex);
        }
        return version;
    }

    /**
     * Provides the level versioning file from cache.
     * @param levelCollectionFeatureToken The GameLevels feature token
     * @return The level versioning file from cache, null if not exists.
     */
    saltr_internal function getLevelVersionsFileFromCache(levelCollectionFeatureToken:String):Object {
        return _repository.getObjectFromCache(getCachedLevelVersionsUrl(levelCollectionFeatureToken));
    }

    /**
     * Stores an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    saltr_internal function saveObject(fileName:String, objectToSave:Object):void {
        _repository.saveObject(fileName, objectToSave);
    }

    /**
     * Caches an level content.
     * @param gameLevelsFeatureToken The "GameLevels" feature token the level belong to.
     * @param globalIndex The global index of the level.
     * @param version The version of the level.
     * @param content The level to store.
     */
    saltr_internal function cacheLevelContent(gameLevelsFeatureToken:String, globalIndex:int, version:String, content:String):void {
        var cachedLevelFileName:String = getCachedLevelUrl(gameLevelsFeatureToken, globalIndex);
        _repository.cacheObject(cachedLevelFileName, content);
        //versions save here
        var cachedLevelVersionsFileName:String = getCachedLevelVersionsUrl(gameLevelsFeatureToken);
        var cachedLevelVersions:Array = _repository.getObjectFromCache(cachedLevelVersionsFileName) as Array;
        if (null == cachedLevelVersions) {
            cachedLevelVersions = [];
        }

        var versionUpdated:Boolean = false;
        for (var i:int = 0, length:int = cachedLevelVersions.length; i < length; ++i) {
            var cachedVersion:Object = cachedLevelVersions[i];
            if (globalIndex == cachedVersion.globalIndex) {
                cachedVersion.version = version;
                versionUpdated = true;
                break;
            }
        }
        if (!versionUpdated) {
            var objectToAdd:Object = {};
            objectToAdd["globalIndex"] = globalIndex;
            objectToAdd["version"] = int(version);
            cachedLevelVersions.push(objectToAdd);
        }

        _repository.cacheObject(cachedLevelVersionsFileName, cachedLevelVersions);
    }

    /**
     * Caches an application data.
     * @param object The object to store.
     */
    saltr_internal function cacheAppData(object:Object):void {
        _repository.cacheObject(getCachedAppDataUrl(), object);
        SLTLogger.getInstance().log("App data cached");
    }

    /**
     * Provides the level_data.json from application.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @return The requested level_data.json from application.
     */
    saltr_internal function getLevelDataFromApplication(gameLevelsFeatureToken:String):Object {
        return _repository.getObjectFromApplication(getLevelDataFromApplicationUrl(_localContentRoot, gameLevelsFeatureToken));
    }

    /**
     * Provides an level object from application.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from application.
     */
    saltr_internal function getLevelFromApplication(path:String):Object {
        return _repository.getObjectFromApplication(SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_URL_TEMPLATE, _localContentRoot, path));
    }


}
}
