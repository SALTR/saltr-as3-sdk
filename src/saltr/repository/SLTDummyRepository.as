/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {
/**
 * The SLTDummyRepository class represents the dummy repository.
 */
public class SLTDummyRepository implements ISLTRepository {

//    private var _applicationDirectory:File;
//    private var _fileStream:FileStream;

    /**
     * Class constructor.
     */
    public function SLTDummyRepository() {
//        _applicationDirectory = File.applicationDirectory;
//        _fileStream = new FileStream();
    }

    /**
     * Defines the local content root.
     * @param contentRoot The content root url.
     */
    public function setLocalContentRoot(contentRoot:String):void {
    }

    /**
     * Provides an object from storage.
     * @param name The name of the object.
     * @return <code>null</code> value.
     */
    public function getObjectFromStorage(name:String):Object {
        return null;
    }

    /**
     * Provides an level object from cache.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from cache.
     */
    public function getLevelFromCache(gameLevelsFeatureToken:String, globalIndex:int):Object {
        return null;
    }

    /**
     * Provides the cached level version.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The version of the cached level.
     */
    public function getLevelVersionFromCache(gameLevelsFeatureToken:String, globalIndex:int):String {
        return "";
    }

    /**
     * Stores an object.
     * @param name The name of the object.
     * @param object The object to store.
     */
    public function saveObject(name:String, object:Object):void {
    }

    /**
     * Caches an level content.
     * @param featureToken The "GameLevels" feature token the level belong to.
     * @param version The version of the level.
     * @param object The level to store.
     */
    public function cacheLevelContent(featureToken:String, version:String, object:Object):void {
    }

    /**
     * Caches an application data.
     * @param object The object to store.
     */
    public function cacheAppData(object:Object):void {
    }

    /**
     * Provides an level object from application.
     * @param gameLevelsFeatureToken The GameLevels feature token
     * @param globalIndex The global identifier of the cached level.
     * @return The requested level from application.
     */
    public function getLevelFromApplication(gameLevelsFeatureToken:String, globalIndex:int):Object {
        return null;
    }

//    private function getInternal(file:File):Object {
//        try {
//            if (!file.exists) {
//                return null;
//            }
//            _fileStream.open(file, FileMode.READ);
//            var stringData:String = _fileStream.readUTFBytes(_fileStream.bytesAvailable);
//            _fileStream.close();
//            return stringData ? JSON.parse(stringData) : null;
//        }
//        catch (error:Error) {
//            trace("[MobileStorageEngine] : error while getting object.\nError : [ID : '" + error.errorID + "', message : '" + error.message + "'");
//        }
//        return null;
//    }
}
}
