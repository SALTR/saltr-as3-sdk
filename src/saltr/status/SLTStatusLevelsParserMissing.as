package saltr.status {

/**
 * The SLTStatusLevelsParserMissing class represents the client levels parse error.
 */
public class SLTStatusLevelsParserMissing extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusLevelsParserMissing() {
        super(CLIENT_LEVELS_PARSE_ERROR, "[SALTR] Failed to find parser for current level type..");
    }
}
}
