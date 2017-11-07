/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {

/**
 * The SLTStatusLevelContentLoadFail class represents the client level content load fail status.
 */
public class SLTStatusLevelContentLoadFail extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusLevelContentLoadFail() {
        super(CLIENT_LEVEL_CONTENT_LOAD_FAIL, "[SALTR] Level content load has failed.");
    }
}
}
