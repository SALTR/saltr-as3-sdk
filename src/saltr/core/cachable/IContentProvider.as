package saltr.core.cachable {
public interface IContentProvider {

    function getContent(cachable:Cachable, contentReceived:Function):void;


    function cache(cachable:Cachable);
}
}
