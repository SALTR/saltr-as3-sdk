/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {
public class SLTStatusAppDataLoadFail extends SLTStatus {
    public function SLTStatusAppDataLoadFail() {
        super(CLIENT_APP_DATA_LOAD_FAIL, "[SALTR] Failed to load appData.");
    }
}
}
