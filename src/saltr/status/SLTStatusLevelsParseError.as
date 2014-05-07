/*
 * Copyright Plexonic Ltd (c) 2014.
 */

/**
 * User: gsar
 * Date: 5/1/14
 * Time: 3:13 PM
 */
package saltr.status {
import saltr.status.SLTStatus;

public class SLTStatusLevelsParseError extends SLTStatus {
    public function SLTStatusLevelsParseError() {
        super(CLIENT_LEVELS_PARSE_ERROR, "[SALTR] Failed to decode Levels.");
    }
}
}
