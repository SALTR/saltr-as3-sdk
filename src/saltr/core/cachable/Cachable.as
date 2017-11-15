package saltr.core.cachable {
public class Cachable {

    protected var _contentUrl:String;
    protected var _version:String;

    public function Cachable() {
    }

    public function get contentUrl():String {
        return _contentUrl;
    }

    public function set contentUrl(value:String):void {
        _contentUrl = value;
    }

    public function get version():String {
        return _version;
    }

    public function set version(value:String):void {
        _version = value;
    }

    public function get cachableIdentifier():String {
        return "";
    }
}
}
