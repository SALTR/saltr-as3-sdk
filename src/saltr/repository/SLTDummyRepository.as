/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.repository {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class SLTDummyRepository implements ISLTRepository {

    private var _applicationDirectory:File;
    private var _fileStream:FileStream;

    public function SLTDummyRepository() {
        _applicationDirectory = File.applicationDirectory;
        _fileStream = new FileStream();
    }

    public function getObjectFromStorage(name:String):Object {
        return null;
    }

    public function getObjectFromCache(fileName:String):Object {
        return null;
    }

    public function getObjectVersion(name:String):String {
        return "";
    }

    public function saveObject(name:String, object:Object):void {
    }

    public function cacheObject(name:String, version:String, object:Object):void {
    }

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
