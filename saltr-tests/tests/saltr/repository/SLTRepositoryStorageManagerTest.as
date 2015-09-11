/**
 * Created by TIGR on 7/20/2015.
 */
package tests.saltr.repository {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.utils.SLTUtils;

use namespace saltr_internal;

public class SLTRepositoryStorageManagerTest {
    [Embed(source="../../../../build/tests/saltr/level_0_chached.json", mimeType="application/octet-stream")]
    private static const LevelDataCachedJson:Class;
    [Embed(source="../../../../build/tests/saltr/slt_repository_test/cached_level_versions.json", mimeType="application/octet-stream")]
    private static const cachedLevelVersionsJson:Class;

    private var _storageManager:SLTRepositoryStorageManager;
    private var _appVersion:String;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;

    public function SLTRepositoryStorageManagerTest() {
    }

    [Before]
    public function tearUp():void {
        _storageManager = new SLTRepositoryStorageManager(mobileRepository);
        _appVersion = SLTUtils.getAppVersion();
    }

    [After]
    public function tearDown():void {
        _storageManager = null;
    }

    /**
     * getLevelVersionFromCacheMissingCachedLevelTest.
     * The intent of this test is to check the getLevelVersionFromCache function.
     * The requested level isn't exists in cache. Null value as the result is expected.
     */
    [Test]
    public function getLevelVersionFromCacheMissingCachedLevelTest():void {
        stub(mobileRepository).method("getObjectFromCache").args("saltr/app_" + _appVersion + "/features/GAME_LEVELS/level_0.json").returns(null);
        stub(mobileRepository).method("getObjectFromCache").args("saltr/app_" + _appVersion + "/features/GAME_LEVELS/level_versions.json").returns(JSON.parse(new cachedLevelVersionsJson()));
        var levelVersion:String = _storageManager.getLevelVersionFromCache("GAME_LEVELS", 0);
        assertEquals(null, levelVersion);
    }

    /**
     * getLevelVersionFromCacheMissingLevelVersionsTest.
     * The intent of this test is to check the getLevelVersionFromCache function.
     * The requested level exists in cache, the versioning file is missing. Null value as the result is expected.
     */
    [Test]
    public function getLevelVersionFromCacheMissingLevelVersionsTest():void {
        stub(mobileRepository).method("getObjectFromCache").args("saltr/app_" + _appVersion + "/features/GAME_LEVELS/level_0.json").returns(JSON.parse(new LevelDataCachedJson()));
        stub(mobileRepository).method("getObjectFromCache").args("saltr/app_" + _appVersion + "/features/GAME_LEVELS/level_versions.json").returns(null);
        var levelVersion:String = _storageManager.getLevelVersionFromCache("GAME_LEVELS", 0);
        assertEquals(null, levelVersion);
    }

    /**
     * cacheLevelContentUpdateExistingTest.
     * The intent of this test is to check the cacheLevelContent function.
     * Level cache information exits, just updated with new value.
     */
    [Test]
    public function cacheLevelContentUpdateExistingTest():void {
        var objectToCache:Object = JSON.parse(new LevelDataCachedJson());
        var cachedLevelVersions:Object = JSON.parse(new cachedLevelVersionsJson());

        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").args("saltr/app_" + _appVersion + "/features/GAME_LEVELS/level_versions.json").returns(cachedLevelVersions);

        var testSuccess:Boolean = false;

        _storageManager.cacheLevelContent("GAME_LEVELS", 0, "52", objectToCache);

        var cachedLevelVersionsArray:Array = cachedLevelVersions as Array;
        for (var i:int = 0; i < cachedLevelVersionsArray.length; ++i) {
            var cachedVersion:Object = cachedLevelVersionsArray[i];
            if (0 == cachedVersion.globalIndex && 52 == cachedVersion.version) {
                testSuccess = true;
                break;
            }
        }
        assertEquals(true, testSuccess);
    }
}
}
