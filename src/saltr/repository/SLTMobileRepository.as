/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: sarg
 * Date: 10/1/12
 * Time: 2:39 PM
 */
package saltr.repository {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class SLTMobileRepository implements ISLTRepository {

    private var _storageDirectory:File;
    private var _applicationDirectory:File;
    private var _cacheDirectory:File;
    private var _fileStream:FileStream;


    public function SLTMobileRepository() {
        _applicationDirectory = File.applicationDirectory;
        _storageDirectory = File.applicationStorageDirectory;
        _cacheDirectory = File.cacheDirectory;
        _fileStream = new FileStream();

        trace("storageDirectory: " + _storageDirectory.nativePath);
        trace("cacheDir: " + _cacheDirectory.nativePath);
    }

    public function getObjectFromStorage(fileName:String):Object {
        var file:File = _storageDirectory.resolvePath(fileName);
        return getInternal(file);
    }

    public function getObjectFromApplication(fileName:String):Object {
        var file:File = _applicationDirectory.resolvePath(fileName);
        return getInternal(file);
    }

    public function getObjectFromCache(fileName:String):Object {
        var file:File = _cacheDirectory.resolvePath(fileName);
        return getInternal(file);

    }

    public function getObjectVersion(name:String):String {
        var file:File = _cacheDirectory.resolvePath(name.replace(".", "") + "_VERSION_");
        var obj:Object = getInternal(file);
        if (obj == null) {
            return null;
        }
        return obj["_VERSION_"];
    }

    public function cacheObject(fileName:String, version:String, object:Object):void {
        var file:File = _cacheDirectory.resolvePath(fileName);
        saveInternal(file, object);
        file = _cacheDirectory.resolvePath(fileName.replace(".", "") + "_VERSION_");
        saveInternal(file, {_VERSION_: version});
    }

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
}
}
