/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.utils.Dictionary;

import saltr.api.SLTApiFactory;
import saltr.repository.ISLTRepository;

public class SLTMobileLevelsFeaturesUpdater extends SLTMobileLevelUpdater implements ISLTMobileLevelUpdater {
    public function SLTMobileLevelsFeaturesUpdater(repository:ISLTRepository, apiFactory:SLTApiFactory, requestIdleTimeout:int) {
        super(repository, apiFactory, requestIdleTimeout);
    }

    public function init(gameLevelsFeatures:Dictionary):void {
    }

    public function update():void {
        //
    }
}
}
