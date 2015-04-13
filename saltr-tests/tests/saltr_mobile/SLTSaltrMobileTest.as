/**
 * Created by TIGR on 4/10/2015.
 */
package tests.saltr_mobile {
import mockolate.runner.MockolateRule;
import mockolate.stub;
import mockolate.verify;

import saltr.repository.SLTMobileRepository;

public class SLTSaltrMobileTest {

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();

    [Mock(type="strict")]
    //[Mock(type="nice")]
    public var strictlyThanks:SLTMobileRepository;

    public function SLTSaltrMobileTest() {
    }

//    [Before(async, timeout=5000)]
//    public function prepareMockolates():void {
//        Async.proceedOnEvent(this,
//                prepare(SLTMobileRepository),
//                Event.COMPLETE);
//    }

    //[Test(expects="mockolate.errors.InvocationError")]
    [Test]
    public function strictlyIfYouMust():void {
        //var flavour:Flavour = strict(DarkChocolate);
        //var repository:SLTMobileRepository = strict(SLTMobileRepository);

        // accessing a property without a mock or stub
        // will cause a strict Mock Object to throw an InvocationError
        //var name:String = flavour.name;
        //repository.getObjectFromCache("kuku");
        //assertThat(repository.getObjectFromCache("kuku"), nullValue());
        //strictlyThanks.getObjectFromCache("kuku");
        //var strictlyThanks:SLTMobileRepository = new SLTMobileRepository();
        //strictlyThanks.cacheObject("kyy", "90", {});
        //strictlyThanks.getObjectVersion("kuku");
        //Assert.assertNotNull(strictlyThanks.getObjectVersion("kuku"));
        //Assert.assertNotNull(strictlyThanks.getObjectVersion("kuku"));

        //mock(strictlyThanks).method("getObjectVersion").returns("Butterscotch");

        //assertThat(strictlyThanks.getObjectVersion("kuku"), nullValue());

        //var flavour:SLTSaltrMobileRepository = nice(SLTSaltrMobileRepository);

        stub(strictlyThanks).method("getObjectVersion").returns("kuku")
                .calls(function ():void {
                    trace("anakonda >>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                });

        strictlyThanks.getObjectVersion("kuku");

        verify(strictlyThanks);

    }

//    [Test]
//    public function nicelyPlease():void
//    {
//        //var flavour:Flavour = nice(Flavour);
//        var repository:SLTMobileRepository = nice(SLTMobileRepository);
//
//        assertThat(repository.getObjectFromCache("kuku"), nullValue());
//    }
}
}
