/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 1/14/14
 * Time: 6:37 PM
 */
package saltr.repository {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class SLTDummyRepository implements ISLTRepository {

    private var _applicationDirectory:File;
    private var _fileStream:FileStream;

    public function SLTDummyRepository() {
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
