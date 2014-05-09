/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {
public class SLTStatusFeaturesParseError extends SLTStatus {
    public function SLTStatusFeaturesParseError() {
        super(CLIENT_FEATURES_PARSE_ERROR, "[SALTR] Failed to decode Features.");
    }
}
}
