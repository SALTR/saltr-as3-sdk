/*
 * Copyright Plexonic Ltd (c) 2014.
 */

/**
 * User: gsar
 * Date: 5/1/14
 * Time: 3:45 PM
 */
package saltr.status {
public class SLTStatusAppDataLoadFail extends SLTStatus {
    public function SLTStatusAppDataLoadFail() {
        super(CLIENT_APP_DATA_LOAD_FAIL, "[SALTR] Failed to load appData.");
    }
}
}
