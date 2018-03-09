/**
 * Created by daal on 6/24/15.
 */
package saltr.repository {
import flash.desktop.NativeApplication;
import flash.filesystem.File;

import saltr.SLTConfig;
import saltr.saltr_internal;
import saltr.utils.SLTLogger;
import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTRepositoryStorageManager {

    private static var INSTANCE:SLTRepositoryStorageManager;

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

    private static function getCachedLevelUrl(levelCollectionToken:String, globalIndex:int, levelVersion:String):String {
        return SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_LEVEL_URL_TEMPLATE, getAppVersion(), levelCollectionToken, globalIndex, levelVersion);
    }

    private static function isCurrentAppVersionCacheDirExists(cacheDirectory:File):Boolean {
        var dir:File = cacheDirectory.resolvePath(SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_CONTENT_ROOT_URL_TEMPLATE, getAppVersion()));
        return dir.exists;
    }

    public static function getInstance():SLTRepositoryStorageManager {
        if (!INSTANCE) {
            INSTANCE = new SLTRepositoryStorageManager();
        }
        return INSTANCE;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private var _repository:SLTMobileRepository;
    private var _localContentRoot:String;

    public function SLTRepositoryStorageManager() {
        _repository = new SLTMobileRepository();
        _localContentRoot = SLTConfig.DEFAULT_CONTENT_ROOT;
    }

    public function cleanupOldAppCache():void {
        var cacheDirectoryListing:Array = _repository.getCacheDirSubFolderListing(SLTConfig.DEFAULT_CONTENT_ROOT);
        if (cacheDirectoryListing != null) {
            var currentAppCacheName:String = "app_" + getAppVersion();
            for (var i:uint = 0, length:uint = cacheDirectoryListing.length; i < length; i++) {
                var appCacheDir:File = cacheDirectoryListing[i];
                var appCacheDirName:String = cacheDirectoryListing[i].name;
                if (appCacheDir.isDirectory && currentAppCacheName != appCacheDirName && appCacheDirName.indexOf("app_") == 0) {
                    cacheDirectoryListing[i].deleteDirectoryAsync(true);
                }
            }
        }
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
     * @param fileName The name of the file.
     * @return The requested object.
     */
    saltr_internal function readObjectFromStorageDir(fileName:String):Object {
        return _repository.readObjectFromStorageDir(fileName);
    }

    /**
     * Provides the cached application data.
     * @return The cached application data.
     */
    saltr_internal function getAppDataFromCache():Object {
        return _repository.readObjectFromCacheDir(getCachedAppDataUrl());
    }


    /**
     * Provides the application data wrapped in package.
     * @return The wrapped in package application data.
     */
    saltr_internal function getAppDataFromApplication():Object {
        return _repository.readObjectFromApplicationDir(getAppDataFromApplicationUrl());
    }

    /**
     * Provides an level object from cache.
     * @param levelCollectionToken The Level Collection feature token
     * @param globalIndex The global identifier of the cached level.
     * @param version The version of the level.
     * @return The requested level from cache.
     */
    saltr_internal function getLevelFromCache(levelCollectionToken:String, globalIndex:int, version:String):Object {
        return _repository.readObjectFromCacheDir(getCachedLevelUrl(levelCollectionToken, globalIndex, version));
    }

    /**
     * Provides a last modified level object from cache.
     * @param levelCollectionToken The Level Collection feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from cache.
     */
    saltr_internal function getLastModifiedLevelFromCache(levelCollectionToken:String, globalIndex:int):Object {
        var versionedLevelsFolder:String = SLTUtils.formatString(SLTConfig.CACHE_VERSIONED_LEVELS_FOLDER, getAppVersion(), levelCollectionToken);
        var cacheDirectoryListing:Array = _repository.getCacheDirSubFolderListing(versionedLevelsFolder, "level_" + globalIndex);
        var result:File = null;
        if (cacheDirectoryListing != null) {
            for (var i:int = 0, len:int = cacheDirectoryListing.length; i < len; ++i) {
                var file:File = cacheDirectoryListing[i];
                if (result == null || file.modificationDate > result.modificationDate) {
                    result = file;
                }
            }
        }
        return result ? _repository.readObjectFromCacheDir(result.url) : null;
    }

    /**
     * Stores an object.
     * @param fileName The name of the file.
     * @param objectToSave The object to store.
     */
    saltr_internal function saveObject(fileName:String, objectToSave:Object):void {
        _repository.writeObjectIntoStorageDir(fileName, objectToSave);
    }

    /**
     * Caches an level content.
     * @param levelCollectionToken The Level Collection feature token the level belong to.
     * @param globalIndex The global index of the level.
     * @param version The version of the level.
     * @param content The level to store.
     */
    saltr_internal function cacheLevelContent(levelCollectionToken:String, globalIndex:int, version:String, content:String):void {
        var cachedLevelFileName:String = getCachedLevelUrl(levelCollectionToken, globalIndex, version);
        _repository.writeObjectIntoCacheDir(cachedLevelFileName, content);
    }

    /**
     * Caches an application data.
     * @param object The object to store.
     */
    saltr_internal function cacheAppData(object:Object):void {
        _repository.writeObjectIntoCacheDir(getCachedAppDataUrl(), object);
        SLTLogger.getInstance().log("App data cached");
    }

    /**
     * Provides the level_data.json from application.
     * @param levelCollectionToken The Level Collection feature token
     * @return The requested level_data.json from application.
     */
    saltr_internal function getLevelDataFromApplication(levelCollectionToken:String):Object {
        return _repository.readObjectFromApplicationDir(getLevelDataFromApplicationUrl(_localContentRoot, levelCollectionToken));
    }

    /**
     * Provides an level object from application.
     * @return The requested level from application.
     * @param path
     */
    saltr_internal function getLevelFromApplication(path:String):Object {
        return _repository.readObjectFromApplicationDir(SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_URL_TEMPLATE, _localContentRoot, path));
    }

    /**
     *  Indicates whether the referenced file
     * @param levelCollectionToken The Level Collection feature token.
     * @param globalIndex The global index of the level.
     * @param version The version of the level.
     * @return true if file exist,false otherwise.
     */
    saltr_internal function cachedLevelFileExists(levelCollectionToken:String, globalIndex:int, version:String):Boolean {
        return _repository.cachedFileExists(getCachedLevelUrl(levelCollectionToken, globalIndex, version));
    }

}
}
