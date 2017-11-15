package saltr.core.cachable {
import flash.utils.Dictionary;

import saltr.SLTFeature;
import saltr.lang.SLTLocale;
import saltr.saltr_internal;

use namespace saltr_internal;

public class LocalizationCacheUpdater extends CacheUpdater {
    private var _localizationFeatures:Dictionary;


    private var _cachedVersionCheckers:Dictionary;
    private var _contentProviders:Dictionary;

    public function LocalizationCacheUpdater(localizationFeatures:Dictionary) {
        _localizationFeatures = localizationFeatures;
        _cachedVersionCheckers = new Dictionary();
        _contentProviders = new Dictionary();
    }

    public function process():void {
        for (var key:String in _localizationFeatures) {
            var f:SLTFeature = _localizationFeatures[key];
            if (_cachedVersionCheckers[key] == null) {
                _cachedVersionCheckers[key] = new LocalizationCachedVersionChecker(key);
                _contentProviders[key] = new LocalizationContentProvider(key);
            }

            processFeature(f);
        }
    }

    private function processFeature(feature:SLTFeature):void {
        var versionChecker:LocalizationCachedVersionChecker = _cachedVersionCheckers[feature.token];
        var contentProvider:IContentProvider = _contentProviders[feature.token];
        for (var i = 0; i < feature.properties.allLocales.length; ++i) {
            var locale:SLTLocale = feature.properties.allLocales[i];
            if (versionChecker.isOutdated(locale)) {

                contentProvider.getContent(locale, contentReceivedCallback);
            }
        }
    }

    override protected function contentReceivedCallback(content:*):void {

    }
}
}
