/**
 * Created by TIGR on 4/10/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTSaltrMobile;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;

/**
 * The SLTSaltrMobileTest class contain the tests which can be performed without saltr.connect()
 */
public class SLTDefineGameLevelsMobileTest {
    [Embed(source="../../../build/tests/saltr/app_data_cache.json", mimeType="application/octet-stream")]
    private static const AppDataFromCacheJson:Class;

    [Embed(source="../../../build/tests/saltr/level_data.json", mimeType="application/octet-stream")]
    private static const AppDataFromApplicationJson:Class;


    private static const localData:Class;
    private static const customPathData:Class;
    private static const appData:Class;


    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    public function SLTDefineGameLevelsMobileTest() {
    }

    [Before]
    public function tearUp():void {
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repositoryStorageManager = new SLTRepositoryStorageManager(mobileRepository);
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    /**
     * defineGameLevelsFromCache.
     * The intent of this test is to check the levels importing from the cache.
     */
    [Test]
    public function defineGameLevelsFromCache():void {
        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new AppDataFromCacheJson()));
        _saltr.defineGameLevels(SLTSaltrTest.GAME_LEVELS_FEATURE);
        assertEquals(5, _saltr.getGameLevelFeatureProperties(SLTSaltrTest.GAME_LEVELS_FEATURE).allLevelsCount);
    }

    /**
     * importLevelsTestFromApplication.
     * The intent of this test is to check the levels importing from the application internal path.
     */
    [Test]
    public function importLevelsTestFromApplication():void {
        stub(mobileRepository).method("getObjectFromCache").returns(null);
        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new AppDataFromApplicationJson()));
        _saltr.defineGameLevels(SLTSaltrTest.GAME_LEVELS_FEATURE);
        assertEquals(75, _saltr.getGameLevelFeatureProperties(SLTSaltrTest.GAME_LEVELS_FEATURE).allLevelsCount);
    }
}
}
