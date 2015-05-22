/**
 * Created by TIGR on 4/27/2015.
 */
package tests.saltr.game.matching {
import org.flexunit.asserts.assertEquals;

import saltr.game.matching.SLTCell;

/**
 * The SLTCellTest class contain the SLTCell method tests.
 */
public class SLTCellTest {
    private var _cell:SLTCell;

    public function SLTCellTest() {
    }

    [Before]
    public function tearUp():void {
        _cell = new SLTCell(10, 20);
    }

    [After]
    public function tearDown():void {
        _cell = null;
    }

    /**
     * getAssetInstanceByEmptyLayerIdTest.
     * The intent of this test is to check the getAssetInstanceByLayerId with passing empty value. Null result value expected.
     */
    [Test]
    public function getAssetInstanceByEmptyLayerIdTest():void {
        assertEquals(null, _cell.getAssetInstanceByLayerId(""));
    }

    /**
     * getAssetInstanceByNullLayerId.
     * The intent of this test is to check the getAssetInstanceByLayerId with passing null value. Null result value expected.
     */
    [Test]
    public function getAssetInstanceByNullLayerId():void {
        assertEquals(null, _cell.getAssetInstanceByLayerId(null));
    }
}
}
