/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import saltr.saltr_internal;
import saltr.utils.gzip.SLTGzipFile;

use namespace saltr_internal;

/**
 * The SLTMobileRepository class represents the mobile repository.
 */
public class SLTMobileRepository {

    private static function getFilteredDirectoryListing(directoryListing:Array, pattern:*):Array {
        var result:Array = [];
        for (var i:int = 0, len:int = directoryListing.length; i < len; ++i) {
            if (directoryListing[i].nativePath.search(pattern) >= 0) {
                result.push(directoryListing[i]);
            }
        }
        return result;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private var _storageDirectory:File;
    private var _applicationDirectory:File;
    private var _cacheDirectory:File;
    private var _fileStream:FileStream;
    private var _isBinary:Boolean;

    /**
     * Class constructor.
     */
    public function SLTMobileRepository(isBinary:Boolean = false) {
        _isBinary = isBinary;
        _applicationDirectory = File.applicationDirectory;
        _storageDirectory = File.applicationStorageDirectory;
        _cacheDirectory = File.cacheDirectory;
        _fileStream = new FileStream();

//        trace("storageDirectory: " + _storageDirectory.nativePath);
//        trace("cacheDir: " + _cacheDirectory.nativePath);
    }

    /**
     * Provides an object from storage.
     * @param fileName The name of the object.
     * @return The requested object.
     */
    public function readObjectFromStorageDir(fileName:String):Object {
        var file:File = _storageDirectory.resolvePath(fileName);
        return _isBinary ? readInternalBinary(file) : readInternalString(file);
    }

    /**
     * Caches an object.
     * @param fileName The name of the object.
     * @param object The object to store.
     */
    public function writeObjectIntoCacheDir(fileName:String, object:Object):void {
        var file:File = _cacheDirectory.resolvePath(fileName);
        _isBinary ? writeInternalBinary(file, object) : writeInternalString(file, object);
    }

    /**
     * Stores an object.
     * @param fileName The name of the object.
     * @param object The object to store.
     */
    public function writeObjectIntoStorageDir(fileName:String, object:Object):void {
        var file:File = _storageDirectory.resolvePath(fileName);
        _isBinary ? writeInternalBinary(file, object) : writeInternalString(file, object);
    }

    /**
     *  Indicates whether the referenced file
     * @param fileName The name of the object.
     * @return true if file exist,false otherwise.
     */
    public function cachedFileExists(fileName:String):Boolean {
        return _cacheDirectory.resolvePath(fileName).exists;
    }

    /**
     *  Provides an array of File objects from cache
     * @param folder
     * @param pattern The pattern to match, which can be any type of object but is typically either a string or a regular expression.
     * @return Returns an array of File objects. Array is filtered by pattern.
     */
    public function getCacheDirSubFolderListing(folder:String, pattern:* = null):Array {
        var dir:File = _cacheDirectory.resolvePath(folder);
        if (dir.exists) {
            var directoryListing:Array = dir.getDirectoryListing();
            if (pattern != null) {
                return getFilteredDirectoryListing(directoryListing, pattern);
            } else {
                return directoryListing;
            }
        } else {
            return null;
        }
    }

    public function readObjectFromCacheDir(fileName:String):Object {
        var file:File = _cacheDirectory.resolvePath(fileName);
        return _isBinary ? readInternalBinary(file) : readInternalString(file);

    }

    public function readObjectFromApplicationDir(fileName:String):Object {
        var file:File = _applicationDirectory.resolvePath(fileName);
        return _isBinary ? readInternalBinary(file) : readInternalString(file);
    }

    private function readInternalString(file:File):Object {
        try {
            if (file.exists) {
                _fileStream.open(file, FileMode.READ);
                var stringData:String = _fileStream.readUTFBytes(_fileStream.bytesAvailable);
                _fileStream.close();
                return stringData ? JSON.parse(stringData) : null;
            }

        }
        catch (error:Error) {
            trace("[SALTR][MobileStorageEngine] Error while getting object.\nError : [ID : '" + error.errorID + "', message : '" + error.message + "'");
        }
        return null;
    }

    private function readInternalBinary(file:File):Object {
        try {
            if (file.exists) {
                return SLTGzipFile.getObjectFromFile(_fileStream, file);
            }
        }
        catch (error:Error) {
            trace("[SALTR][MobileStorageEngine] Error while getting object.\nError : [ID : '" + error.errorID + "', message : '" + error.message + "'");
        }
        return null;
    }

    private function writeInternalString(file:File, objectToSave:Object):void {
        try {
            var objectAsString:String = objectToSave is String ? objectToSave as String : JSON.stringify(objectToSave);
            _fileStream.open(file, FileMode.WRITE);
            _fileStream.writeUTFBytes(objectAsString);
            _fileStream.close();
        }
        catch (error:Error) {
            trace("[SALTR][MobileStorageEngine] Error while saving object.\nError : [ID : '" + error.errorID + "', message : '" + error.message + "'");
        }
    }

    private function writeInternalBinary(file:File, objectToSave:Object):void {
        try {
            var compressedByteArray:ByteArray = objectToSave as ByteArray;
            if (compressedByteArray) {
                _fileStream.open(file, FileMode.WRITE);
                _fileStream.writeBytes(compressedByteArray);
                _fileStream.close();
            } else {
                SLTGzipFile.compressObjectToFile(objectToSave, _fileStream, file);
            }
        }
        catch (error:Error) {
            trace("[SALTR][MobileStorageEngine] Error while saving object.\nError : [ID : '" + error.errorID + "', message : '" + error.message + "'");
        }
    }
}
}