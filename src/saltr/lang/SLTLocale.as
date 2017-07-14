/**
 * Created by tyom on 6/27/2017.
 */
package saltr.lang {
import flash.utils.Dictionary;

public class SLTLocale {
    private var _contentUrl:String;
    private var _alternateContentUrl:String;

    private var _version:String;
    private var _langData:Dictionary;

    /**
     * The current version of the level.
     */
    public function get version():String {
        return _version;
    }

    public function get alternateContentUrl():String {
        return _alternateContentUrl;
    }

    public function set alternateContentUrl(value:String):void {
        _alternateContentUrl = value;
    }

    /**
     * The content URL of the level.
     */
    public function get contentUrl():String {
        return _contentUrl;
    }

    public function set contentUrl(value:String):void {
        _contentUrl = value;
    }

    public function SLTLocale(contentUrl:String, version:String) {
        _contentUrl=contentUrl;
        _version=version;
    }

    public function updateContent(data:Object):void {
        _langData = new Dictionary();
        for (var token:String in data) {
            //var levelPropertyNode:Object = levelPropertyNodes[token];
            _langData[token] = data[token];
        }
    }
}
}
