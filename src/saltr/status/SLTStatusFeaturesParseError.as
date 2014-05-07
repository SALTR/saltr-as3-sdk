/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: gsar
 * Date: 5/1/14
 * Time: 3:08 PM
 */
package saltr.status {
import saltr.status.SLTStatus;

public class SLTStatusFeaturesParseError extends SLTStatus {
    public function SLTStatusFeaturesParseError() {
        super(CLIENT_FEATURES_PARSE_ERROR, "[SALTR] Failed to decode Features.");
    }
}
}
