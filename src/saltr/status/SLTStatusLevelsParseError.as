/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.status {

/**
 * The SLTStatusLevelsParseError class represents the client levels parse error status.
 */
public class SLTStatusLevelsParseError extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusLevelsParseError() {
        super(CLIENT_LEVELS_PARSE_ERROR, "[SALTR] Failed to decode Levels.");
    }
}
}
