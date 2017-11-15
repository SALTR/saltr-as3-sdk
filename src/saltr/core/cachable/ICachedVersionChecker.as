package saltr.core.cachable {
public interface ICachedVersionChecker {

    function isOutdated(cachable:Cachable):Boolean;
}
}
