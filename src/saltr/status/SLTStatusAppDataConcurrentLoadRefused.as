/**
 * Created by daal on 10/30/14.
 */
package saltr.status {

/**
 * The SLTStatusAppDataConcurrentLoadRefused class represents the client app data concurrent load refused status.
 */
public class SLTStatusAppDataConcurrentLoadRefused extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusAppDataConcurrentLoadRefused() {
        super(CLIENT_APP_DATA_CONCURRENT_LOAD_REFUSED, "[SALTR] appData load refused. Previous load is not complete");
    }
}
}
