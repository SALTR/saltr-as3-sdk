/**
 * Created by TIGR on 4/27/2015.
 */
package tests.saltr.game.matching {
import org.flexunit.asserts.assertEquals;

import saltr.game.matching.SLTCell;
import saltr.game.matching.SLTCells;

/**
 * The SLTCellsTest class contain the SLTCells method tests.
 */
public class SLTCellsTest {
    private var _cells:SLTCells;
    public function SLTCellsTest() {
    }

    [Before]
    public function tearUp():void {
        _cells = new SLTCells(10, 20);
    }

    [After]
    public function tearDown():void {
        _cells = null;
    }

    /**
     * insertRetrieveTest.
     * The intent of this test is to check the insert and retrieve.
     */
    [Test]
    public function insertRetrieveTest():void {
        var col:int = 3;
        var row:int = 5;
        _cells.insert(col, row, new SLTCell(col, row));
        assertEquals(3, _cells.retrieve(col, row).col);
        assertEquals(5, _cells.retrieve(col, row).row);
    }
}
}
