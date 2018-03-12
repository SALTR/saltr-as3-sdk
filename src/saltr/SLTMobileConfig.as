/**
 * Created by @ahak on 3/12/2018.
 */
package saltr {
import flash.desktop.NativeApplication;
use namespace saltr_internal;

public class SLTMobileConfig {

    saltr_internal static const APP_VERSION:String = getAppVersion();


    saltr_internal static const CACHED_CONTENT_ROOT_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_" + APP_VERSION;
    saltr_internal static const CACHED_APP_DATA_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_" + APP_VERSION + "/app_data_cache.json";
    saltr_internal static const CACHED_LEVEL_CONTENTS_FOLDER_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_" + APP_VERSION + "/features/{0}";
    saltr_internal static const CACHED_LEVEL_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_" + APP_VERSION + "/features/{0}/level_{1}_{2}.json";

    saltr_internal static const SNAPSHOT_LEVEL_DATA_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/features/{0}/level_data.json";
    saltr_internal static const SNAPSHOT_LEVEL_CONTENT_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/{0}";
    saltr_internal static const SNAPSHOT_APP_DATA_URL_TEMPLATE:String = DEFAULT_CONTENT_ROOT + "/app_data.json";

    saltr_internal static const DEFAULT_CONTENT_ROOT:String = "saltr";

    private static function getAppVersion():String {
        var applicationDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
        var ns:Namespace = applicationDescriptor.namespace();
        return applicationDescriptor.ns::versionNumber[0].toString();
    }
}
}
