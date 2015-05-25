/**
 * Created by TIGR on 4/17/2015.
 */
package tests.saltr {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;

import saltr.AppData;

/**
 * The AppDataTest class contain the AppData method tests
 */
public class AppDataTest {
    [Embed(source="../../../build/tests/saltr/app_data.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;

    private var _appData:AppData;

    public function AppDataTest() {
    }

    [Before]
    public function tearUp():void {
        _appData = new AppData();
    }

    [After]
    public function tearDown():void {
        _appData = null;
    }

    /**
     * initEmptyTest.
     * The intent of this test is to check the initEmpty method.
     */
    [Test]
    public function initEmptyTest():void {
        _appData.defineFeature("SETTINGS", {
            general: {
                lifeRefillTime: 30
            }
        }, true);
        _appData.initEmpty();
        var tokens:Vector.<String> = _appData.getActiveFeatureTokens();

        var testPassed:Boolean = false;
        if (1 == tokens.length && "SETTINGS" == tokens[0]) {
            testPassed = true;
        }
        assertEquals(true, testPassed);
    }

    /**
     * initWithDataTest.
     * The intent of this test is to check the initWithData method.
     */
    [Test]
    public function initWithDataTest():void {
        _appData.initWithData(JSON.parse(new AppDataJson()));

        var testPassed:Boolean = false;
        if (1 == _appData.experiments.length && 5 == _appData.getActiveFeatureTokens().length) {
            testPassed = true;
        }
        assertEquals(true, testPassed);
    }

    /**
     * defineFeatureTestWithIncorrectToken.
     * The intent of this test is to check the defineFeature method with incorrect token. Error should be thrown.
     */
    [Test(expects="Error")]
    public function defineFeatureTestWithIncorrectToken():void {
        _appData.defineFeature("SETTINGS INCORRECT", {
            general: {
                lifeRefillTime: 30
            }
        }, true);
    }

    /**
     * defineFeatureTestWithNullToken.
     * The intent of this test is to check the defineFeature method with null token. Error should be thrown.
     */
    [Test(expects="Error")]
    public function defineFeatureTestWithNullToken():void {
        _appData.defineFeature(null, {
            general: {
                lifeRefillTime: 30
            }
        }, true);
    }

    /**
     * defineFeatureTestWithEmptyToken.
     * The intent of this test is to check the defineFeature method with empty token. Error should be thrown.
     */
    [Test(expects="Error")]
    public function defineFeatureTestWithEmptyToken():void {
        _appData.defineFeature("", {
            general: {
                lifeRefillTime: 30
            }
        }, true);
    }

    /**
     * getActiveFeatureTokensTest.
     * The intent of this test is to check the getActiveFeatureTokens method.
     */
    [Test]
    public function getActiveFeatureTokensTest():void {
        _appData.defineFeature("SETTINGS", {
            general: {
                lifeRefillTime: 30
            }
        }, true);
        _appData.defineFeature("VALIDATION", {
            general: {
                validationTimeout: 50
            }
        }, true);
        _appData.initEmpty();
        var tokens:Vector.<String> = _appData.getActiveFeatureTokens();

        var testPassed:Boolean = false;
        if (2 == tokens.length && -1 != tokens.indexOf("VALIDATION")) {
            testPassed = true;
        }
        assertEquals(true, testPassed);
    }

    /**
     * getFeaturePropertiesWithActiveFeaturesTest.
     * The intent of this test is to check the getFeatureProperties method. In this test active features will be returned.
     */
    //TODO:: @daal. Is this correct test implementation? The correct flow is : first define features. Then initWithData...
    [Test]
    public function getFeaturePropertiesWithActiveFeaturesTest():void {
        _appData.initWithData(JSON.parse(new AppDataJson()));
        _appData.defineFeature("SETTINGS", {
            general: {
                lifeRefillTime: 30
            }
        }, true);
        assertEquals(5, _appData.getFeatureProperties("SETTINGS").general.lifeRefillTime);
    }

    /**
     * getFeaturePropertiesWithDeveloperFeaturesTest.
     * The intent of this test is to check the getFeatureProperties method. In this test developer features will be returned.
     */
    //TODO:: @daal. Is this correct test implementation? The correct flow is : first define features. Then initWithData...
    [Test]
    public function getFeaturePropertiesWithDeveloperFeaturesTest():void {
        _appData.initWithData(JSON.parse(new AppDataJson()));
        _appData.defineFeature("SETTINGS_DEVELOPER", {
            general: {
                lifeRefillTime: 30
            }
        }, true);
        assertEquals(30, _appData.getFeatureProperties("SETTINGS_DEVELOPER").general.lifeRefillTime);
    }

    /**
     * getFeaturePropertiesWithNullResultTest.
     * The intent of this test is to check the getFeatureProperties method. In this test null be returned.
     */
    //TODO:: @daal. Is this correct test implementation? The correct flow is : first define features. Then initWithData...
    [Test]
    public function getFeaturePropertiesWithNullResultTest():void {
        _appData.initWithData(JSON.parse(new AppDataJson()));
        _appData.defineFeature("SETTINGS_DEVELOPER", {
            general: {
                lifeRefillTime: 30
            }
        }, false);
        assertEquals(null, _appData.getFeatureProperties("SETTINGS_DEVELOPER"));
    }
}
}
