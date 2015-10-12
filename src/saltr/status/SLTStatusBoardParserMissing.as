package saltr.status {

/**
 * The SLTStatusBoardParserMissing class represents the client levels parse error.
 */
public class SLTStatusBoardParserMissing extends SLTStatus {

    /**
     * Class constructor.
     */
    public function SLTStatusBoardParserMissing() {
        super(CLIENT_BOARD_PARSE_ERROR, "[SALTR] Failed to find parser for current board type..");
    }
}
}
