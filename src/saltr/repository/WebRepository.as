/**
 * User: sarg
 * Date: 1/14/14
 * Time: 6:37 PM
 */
package saltr.repository {
//TODO @sarg: not implemented yet!
public class WebRepository implements IRepository {
    public function WebRepository() {
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
        return null;
    }
}
}
