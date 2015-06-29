///**
// * Created by daal on 4/14/15.
// */
//package tests.saltr {
//import mockolate.runner.MockolateRule;
//import mockolate.stub;
//
//import org.flexunit.asserts.assertEquals;
//import org.flexunit.asserts.assertNotNull;
//
//import saltr.SLTSaltrMobile;
//
//import saltr.api.SLTApiCallResult;
//import saltr.api.SLTApiFactory;
//import saltr.saltr_internal;
//import saltr.status.SLTStatus;
//
//use namespace saltr_internal;
//
//public class SLTSampleTest {
//
//    [Rule]
//    public var mocks:MockolateRule = new MockolateRule();
//
//    [Mock(type="nice")]
//    public var _heartbeatMock:ApiCallMock;
//    [Mock(type="nice")]
//    public var _apiFactory:SLTApiFactory;
//    private var _saltr:SLTSaltrMobile;
//
//    public function SLTSampleTest() {
//    }
//
//    [Before]
//    public function tearUp():void {
//        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, "", "");
//        stub(_heartbeatMock).method("getMockedCallResult").returns(createMockedCallResult());
//        stub(_apiFactory).method("getCall").returns(_heartbeatMock);
//
//        _saltr.apiFactory = _apiFactory;
//    }
//
//    [After]
//    public function tearDown():void {
//    }
//
//    [Test (async)]
//    public function testSample():void {
//        _saltr.doCallbackTest(AsyncUtil.asyncHandler(this, ttt));
//    }
//
//
//    private function ttt(apiResult : SLTApiCallResult) : void {
//        assertEquals("RRR",apiResult.status.statusMessage);
//    }
//
//    private function createMockedCallResult():SLTApiCallResult {
//        var apiCallResult:SLTApiCallResult = new SLTApiCallResult();
//        var status:SLTStatus = new SLTStatus(SLTStatus.API_ERROR, "RRR");
//        apiCallResult.status = status;
//        return apiCallResult;
//    }
//}
//}