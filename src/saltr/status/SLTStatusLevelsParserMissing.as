package saltr.status {
public class SLTStatusLevelsParserMissing extends SLTStatus {
    public function SLTStatusLevelsParserMissing() {
        super(CLIENT_LEVELS_PARSE_ERROR, "[SALTR] Failed to find parser for current level type..");
    }
}
}
