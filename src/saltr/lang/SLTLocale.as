/**
 * Created by tyom on 6/27/2017.
 */
package saltr.lang {
import flash.utils.Dictionary;

import saltr.core.cachable.Cachable;

public class SLTLocale extends Cachable{

    private var _alternateContentUrl:String;
    private var _langData:Dictionary;
    private var _locale:String;

    public function get alternateContentUrl():String {
        return _alternateContentUrl;
    }

    public function set alternateContentUrl(value:String):void {
        _alternateContentUrl = value;
    }

    public function SLTLocale(locale : String, contentUrl:String, version:String) {
        _locale = locale;
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

    override public function get cachableIdentifier():String{
        return _locale;
    }
}
}
