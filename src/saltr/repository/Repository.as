/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
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

public class Repository implements IRepository {
    public static const FROM_STORAGE:int = 1;
    public static const FROM_CACHE:int = 2;
    public static const FROM_APP:int = 3;

    private var _storageDirectory:File;
    private var _applicationDirectory:File;
    private var _cacheDirectory:File;
    private var _fileStream:FileStream;


    public function Repository() {
        _applicationDirectory = File.applicationDirectory;
        _storageDirectory = File.applicationStorageDirectory;
        _cacheDirectory = File.cacheDirectory;
        _fileStream = new FileStream();

        trace("storageDirectory: " + _storageDirectory.nativePath);
        trace("cacheDir: " + _cacheDirectory.nativePath);
    }

    public function getObject(fileName:String, from:int = Repository.FROM_STORAGE):Object {
        var directory:File = getDirectory(from);
        if (directory) {
            var file:File = directory.resolvePath(fileName);
            return getInternal(file);
        }
        return null;
    }

    public function getObjectVersion(name:String, from:int = Repository.FROM_STORAGE):String {
        var directory:File = getDirectory(from);
        if (directory) {
            var file:File = directory.resolvePath(name.replace(".", "") + "_VERSION_");
            var obj:Object = getInternal(file);
            if (obj == null) {
                return null;
            }
            return obj["_VERSION_"];
        }
        return null;
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

    private function getDirectory(from:int):File {
        switch (from) {
            case Repository.FROM_STORAGE:
                return _storageDirectory;
            case Repository.FROM_CACHE:
                return _cacheDirectory;
            case Repository.FROM_APP:
                return _applicationDirectory;
            default:
                return null;
        }
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
