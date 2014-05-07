/*
 * Copyright Plexonic Ltd (c) 2014.
 */

/**
 * User: gsar
 * Date: 5/1/14
 * Time: 3:11 PM
 */
package saltr.status {
import saltr.status.SLTStatus;

public class SLTStatusExperimentsParseError extends SLTStatus {
    public function SLTStatusExperimentsParseError() {
        super(SLTStatus.CLIENT_EXPERIMENTS_PARSE_ERROR, "[SALTR] Failed to decode Experiments.");
    }
}
}
