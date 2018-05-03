/**
 * Created by daal on 6/24/15.
 */
package saltr.repository {
import flash.filesystem.File;

import saltr.SLTMobileConfig;
import saltr.saltr_internal;
import saltr.utils.SLTLogger;
import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTRepositoryStorageManager {

    private static var INSTANCE:SLTRepositoryStorageManager;

    private static function getSnapshotLevelDataUrl(token:String, isBinary:Boolean):String {
        return SLTUtils.formatString(SLTMobileConfig.SNAPSHOT_LEVEL_DATA_URL_TEMPLATE, token, isBinary ? "bin" : "json");
    }

    private static function getCachedLevelContentUrl(levelCollectionToken:String, globalIndex:int, levelVersion:String, isBinary:Boolean):String {
        return SLTUtils.formatString(SLTMobileConfig.CACHED_LEVEL_URL_TEMPLATE, levelCollectionToken, globalIndex, levelVersion, isBinary ? "bin" : "json");
    }

    private static function isCurrentAppVersionCacheDirExists(cacheDirectory:File):Boolean {
        var dir:File = cacheDirectory.resolvePath(SLTMobileConfig.CACHED_CONTENT_ROOT_URL_TEMPLATE);
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
    private var _isBinary:Boolean;

    public function SLTRepositoryStorageManager() {
        _repository = new SLTMobileRepository();
    }

    saltr_internal function set isBinary(value:Boolean):void {
        _isBinary = value;
    }

    public function cleanupOldAppCache():void {
        var cacheDirectoryListing:Array = _repository.getCacheDirSubFolderListing(SLTMobileConfig.DEFAULT_CONTENT_ROOT);
        if (cacheDirectoryListing != null) {
            var currentAppCacheName:String = "app_" + SLTMobileConfig.APP_VERSION;
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
     * Provides an object from storage.
     * @param fileName The name of the file.
     * @return The requested object.
     */
    saltr_internal function readObjectFromStorageDir(fileName:String):Object {
        return _repository.readObjectFromStorageDir(fileName,_isBinary);
    }

    /**
     * Provides the cached application data.
     * @return The cached application data.
     */
    saltr_internal function getAppDataFromCache():Object {
        return _repository.readObjectFromCacheDir(_isBinary ? SLTMobileConfig.CACHED_APP_DATA_BINARY_URL_TEMPLATE : SLTMobileConfig.CACHED_APP_DATA_JSON_URL_TEMPLATE,_isBinary);
    }


    /**
     * Provides the application data wrapped in package.
     * @return The wrapped in package application data.
     */
    saltr_internal function getAppDataFromSnapshot():Object {
        return _repository.readObjectFromApplicationDir(_isBinary ? SLTMobileConfig.SNAPSHOT_APP_DATA_BINARY_URL_TEMPLATE : SLTMobileConfig.SNAPSHOT_APP_DATA_JSON_URL_TEMPLATE, _isBinary);
    }

    /**
     * Provides an level object from cache.
     * @param levelCollectionToken The Level Collection feature token
     * @param globalIndex The global identifier of the cached level.
     * @param version The version of the level.
     * @return The requested level from cache.
     */
    saltr_internal function getLevelContentFromCache(levelCollectionToken:String, globalIndex:int, version:String):Object {
        return _repository.readObjectFromCacheDir(getCachedLevelContentUrl(levelCollectionToken, globalIndex, version, _isBinary),_isBinary);
    }

    /**
     * Provides a last modified level object from cache.
     * @param levelCollectionToken The Level Collection feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from cache.
     */
    saltr_internal function getLastModifiedLevelFromCache(levelCollectionToken:String, globalIndex:int):Object {
        var levelContentsFolderURL:String = SLTUtils.formatString(SLTMobileConfig.CACHED_LEVEL_CONTENTS_FOLDER_URL_TEMPLATE, levelCollectionToken);
        var cacheDirectoryListing:Array = _repository.getCacheDirSubFolderListing(levelContentsFolderURL, "level_" + globalIndex);
        var result:File = null;
        if (cacheDirectoryListing != null) {
            for (var i:int = 0, len:int = cacheDirectoryListing.length; i < len; ++i) {
                var file:File = cacheDirectoryListing[i];
                if (result == null || file.modificationDate > result.modificationDate) {
                    result = file;
                }
            }
        }
        return result ? _repository.readObjectFromCacheDir(result.url,_isBinary) : null;
    }

    /**
     * Stores an object.
     * @param fileName The name of the file.
     * @param objectToSave The object to store.
     */
    saltr_internal function saveObject(fileName:String, objectToSave:Object):void {
        _repository.writeObjectIntoStorageDir(fileName, objectToSave, _isBinary);
    }

    /**
     * Caches an level content.
     * @param levelCollectionToken The Level Collection feature token the level belong to.
     * @param globalIndex The global index of the level.
     * @param version The version of the level.
     * @param content The level to store.
     */
    saltr_internal function cacheLevelContent(levelCollectionToken:String, globalIndex:int, version:String, content:Object):void {
        var cachedLevelFileName:String = getCachedLevelContentUrl(levelCollectionToken, globalIndex, version, _isBinary);
        _repository.writeObjectIntoCacheDir(cachedLevelFileName, content, _isBinary);
    }

    /**
     * Caches an application data.
     * @param object The object to store.
     */
    saltr_internal function cacheAppData(object:Object):void {
        _repository.writeObjectIntoCacheDir(_isBinary ? SLTMobileConfig.CACHED_APP_DATA_BINARY_URL_TEMPLATE : SLTMobileConfig.CACHED_APP_DATA_JSON_URL_TEMPLATE, object, _isBinary);
        SLTLogger.getInstance().log("App data cached");
    }

    /**
     * Provides the level_data.json from application.
     * @param levelCollectionToken The Level Collection feature token
     * @return The requested level_data.json from application.
     */
    saltr_internal function getLevelDataFromSnapshot(levelCollectionToken:String):Object {
        return _repository.readObjectFromApplicationDir(getSnapshotLevelDataUrl(levelCollectionToken, _isBinary), _isBinary);
    }

    /**
     * Provides an level object from application.
     * @return The requested level content from application.
     * @param url
     */
    saltr_internal function getLevelContentFromSnapshot(url:String):Object {
        return _repository.readObjectFromApplicationDir(SLTUtils.formatString(SLTMobileConfig.SNAPSHOT_LEVEL_CONTENT_URL_TEMPLATE, url), _isBinary);
    }

    /**
     *  Indicates whether the referenced file
     * @param levelCollectionToken The Level Collection feature token.
     * @param globalIndex The global index of the level.
     * @param version The version of the level.
     * @return true if file exist,false otherwise.
     */
    saltr_internal function isCachedLevelContentFileExists(levelCollectionToken:String, globalIndex:int, version:String):Boolean {
        return _repository.cachedFileExists(getCachedLevelContentUrl(levelCollectionToken, globalIndex, version, _isBinary));
    }

}
}
