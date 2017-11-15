package saltr.core.cachable {
import saltr.api.call.SLTApiCall;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

public class LocalizationContentProvider implements IContentProvider {

    private var _repositoryStorageManager:SLTRepositoryStorageManager;
    private var _featureToken:String;

    public function LocalizationContentProvider(featureToken:String) {
        _featureToken = featureToken;
    }

    public function getContent(cachable:Cachable, contentReceived:Function):void {
    }

    public function cache(cachable:Cachable) {
        var params:Object = {
            contentUrl: cachable.contentUrl
        };
        var levelContentApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_LOCALE_CONTENT);

        new ApiCommand(levelContentApiCall, params, successHandler, failHandler);

        function successHandler(data:Object):void {
            _repositoryStorageManager.cacheLocalizationContent(_featureToken, cachable.cachableIdentifier, cachable.version, data);
        }

        function failHandler(status:SLTStatus):void {
        }
    }
}

}

import flash.events.Event;
import flash.events.EventDispatcher;

import saltr.api.call.SLTApiCall;
import saltr.saltr_internal;
import saltr.status.SLTStatus;
import saltr.utils.commands.CommandController;
import saltr.utils.commands.ICommand;

use namespace saltr_internal;

class ApiCommand extends EventDispatcher implements ICommand {
    private var _commandController:CommandController;
    private var _apiCall:SLTApiCall;
    private var _successHandler:Function;
    private var _failHandler:Function;
    private var _params:Object;


    public function ApiCommand(apiCall:SLTApiCall, params:Object, successHandler:Function, failHandler:Function) {
        _commandController = CommandController.getInstance();
        _apiCall = apiCall;
        _params = params;

        _successHandler = successHandler;
        _failHandler = failHandler;
    }

    public function execute():void {
        _apiCall.call(_params, successHandler, failHandler);
    }

    function successHandler(data:Object):void {
        _successHandler(data);
        dispatchDone();
    }

    function failHandler(status:SLTStatus):void {
        _failHandler(status);
        dispatchDone();
    }

    public function call():void {
        _commandController.add(this);
    }

    private function dispatchDone():void {
        dispatchEvent(new Event(CommandController.EVENT_DONE));
    }
}
