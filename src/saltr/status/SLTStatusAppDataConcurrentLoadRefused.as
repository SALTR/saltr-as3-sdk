/**
 * Created by daal on 10/30/14.
 */
package saltr.status {
public class SLTStatusAppDataConcurrentLoadRefused extends SLTStatus {

    public function SLTStatusAppDataConcurrentLoadRefused() {
        super(CLIENT_APP_DATA_CONCURRENT_LOAD_REFUSED, "[SALTR] appData load refused. Previous load is not complete");
    }
}
}
