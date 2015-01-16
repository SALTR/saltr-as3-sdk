/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {

/**
 * The SLTStatusFeaturesParseError class represents the client features parse error status.
 */
public class SLTStatusFeaturesParseError extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusFeaturesParseError() {
        super(CLIENT_FEATURES_PARSE_ERROR, "[SALTR] Failed to decode Features.");
    }
}
}
