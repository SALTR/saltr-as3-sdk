///**
// * Created by TIGR on 4/10/2015.
// */
//package tests.saltr {
//import mockolate.runner.MockolateRule;
//import mockolate.stub;
//
//import org.flexunit.asserts.assertEquals;
//
//import saltr.SLTSaltrMobile;
//import saltr.repository.SLTMobileRepository;
//
///**
// * The SLTSaltrMobileTest class contain the tests which can be performed without saltr.connect()
// */
//public class SLTImportLevelsMobileTest {
//    [Embed(source="../../../build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
//    private static const AppDataJson:Class;
//
//    [Embed(source="../../../build/tests/saltr/level_packs_1_pack.json", mimeType="application/octet-stream")]
//    private static const AppDataWithOnePackJson:Class;
//
//    [Embed(source="../../../build/tests/saltr/level_packs_2_pack.json", mimeType="application/octet-stream")]
//    private static const AppDataWithTwoPacksJson:Class;
//
//
//    private static const localData:Class;
//    private static const customPathData:Class;
//    private static const appData:Class;
//
//
//    [Rule]
//    public var mocks:MockolateRule = new MockolateRule();
//    [Mock(type="nice")]
//    public var mobileRepository:SLTMobileRepository;
//
//    private var clientKey:String = "";
//    private var deviceId:String = "";
//    private var _saltr:SLTSaltrMobile;
//
//    public function SLTImportLevelsMobileTest() {
//    }
//
//    [Before]
//    public function tearUp():void {
//        stub(mobileRepository).method("getObjectFromApplication").args("onePack").returns(JSON.parse(new AppDataWithOnePackJson()));
//        stub(mobileRepository).method("getObjectFromApplication").args("saltr/level_packs.json").returns(JSON.parse(new AppDataWithTwoPacksJson()));
//        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
//        _saltr.repository = mobileRepository;
//    }
//
//    [After]
//    public function tearDown():void {
//        _saltr = null;
//    }
//
//    /**
//     * importLevelsTestFromProvidedPath.
//     * The intent of this test is to check the levels importing from the provided path.
//     */
//    [Test]
//    public function importLevelsTestFromProvidedPath():void {
//        _saltr.importLevels("onePack");
//        assertEquals(15, _saltr.allLevelsCount);
//    }
//
//    /**
//     * importLevelsTestFromCache.
//     * The intent of this test is to check the levels importing from the cache.
//     */
//    [Test]
//    public function importLevelsTestFromCache():void {
//        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new AppDataJson()));
//        _saltr.importLevels(null);
//        assertEquals(75, _saltr.allLevelsCount);
//    }
//
//    /**
//     * importLevelsTestFromApplication.
//     * The intent of this test is to check the levels importing from the application internal path.
//     */
//    [Test]
//    public function importLevelsTestFromApplication():void {
//        _saltr.importLevels(null);
//        assertEquals(30, _saltr.allLevelsCount);
//    }
//}
//}
