/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {

/**
 * The SLTStatusAppDataLoadFail class represents the client app data load fail status.
 */
public class SLTStatusAppDataLoadFail extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusAppDataLoadFail() {
        super(CLIENT_APP_DATA_LOAD_FAIL, "[SALTR] Failed to load appData.");
    }
}
}
