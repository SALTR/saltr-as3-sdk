/**
 * User: sarg
 * Date: 1/14/14
 * Time: 6:37 PM
 */
package saltr.storage {
//TODO @GSAR: rename class!
public class StorageDummy implements IStorage{
    public function StorageDummy() {
    }

    public function getObject(name:String, from:int = 1):Object {
        return null;
    }

    public function getObjectVersion(name:String, from:int = 1):String {
        return "";
    }

    public function saveObject(name:String, object:Object):void {
    }

    public function cacheObject(name:String, version:String, object:Object):void {
    }
}
}
