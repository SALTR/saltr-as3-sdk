package saltr.core.cachable {
import saltr.saltr_internal;

use namespace saltr_internal;

public class CacheUpdater {

    protected var _contentProvider:IContentProvider;
    protected var _cachedVersionChecker: ICachedVersionChecker;
    protected var _cachables:Array;

    public function update(callback:Function = null):void {

        for (var i:int = 0; i < _cachables.length; ++i) {
            if(_cachedVersionChecker.isOutdated(_cachables[i])) {
                _contentProvider.getContent(_cachables[i], contentReceivedCallback);
            }
        }

        if (callback) {
            callback();
        }
    }

    protected function contentReceivedCallback(content:*):void {
        //cache....
    }
}
}
