package saltr.core.cachable {
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;

use namespace saltr_internal;

public class LocalizationCachedVersionChecker implements ICachedVersionChecker {

    private var _repositoryStorageManager:SLTRepositoryStorageManager;
    private var _versionsData:Object;

    public function LocalizationCachedVersionChecker(featureToken:String) {
        _versionsData =_repositoryStorageManager.getLocalizationVersionsFileFromCache(featureToken);
    }

    public function isOutdated(cachable:Cachable):Boolean {
        return _versionsData == null || cachable.version != getCachedVersion(cachable.cachableIdentifier);
    }

    private function getCachedVersion(cachableIdentifier:String):String {
        return "";
    }
}
}
