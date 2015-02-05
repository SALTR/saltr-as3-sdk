/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {

/**
 * The SLTStatusAppDataParseError class represents the client experiments parse error status.
 */
public class SLTStatusAppDataParseError extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusAppDataParseError() {
        super(SLTStatus.CLIENT_APP_DATA_PARSE_ERROR, "[SALTR] Failed to decode appData.");
    }
}
}
