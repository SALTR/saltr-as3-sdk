/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

/**
 * The SLTDummyRepository class represents the dummy repository.
 */
public class SLTDummyRepository implements ISLTRepository {

    private var _applicationDirectory:File;
    private var _fileStream:FileStream;

    /**
     * Class constructor.
     */
    public function SLTDummyRepository() {
        _applicationDirectory = File.applicationDirectory;
        _fileStream = new FileStream();
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
     * Provides an object from cache.
     * @param fileName The name of the object.
     * @return <code>null</code> value.
     */
    public function getObjectFromCache(fileName:String):Object {
        return null;
    }

    /**
     * Provides the object's version.
     * @param name The name of the object.
     * @return The empty value.
     */
    public function getObjectVersion(name:String):String {
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
     * Caches an object.
     * @param name The name of the object.
     * @param version The version of the object.
     * @param object The object to store.
     */
    public function cacheObject(name:String, version:String, object:Object):void {
    }

    /**
     * Provides an object from application.
     * @param fileName The name of the object.
     * @return The requested object.
     */
    public function getObjectFromApplication(fileName:String):Object {
        var file:File = _applicationDirectory.resolvePath(fileName);
        return getInternal(file);
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
}
}
