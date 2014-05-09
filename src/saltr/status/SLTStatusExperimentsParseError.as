/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {
public class SLTStatusExperimentsParseError extends SLTStatus {
    public function SLTStatusExperimentsParseError() {
        super(SLTStatus.CLIENT_EXPERIMENTS_PARSE_ERROR, "[SALTR] Failed to decode Experiments.");
    }
}
}
