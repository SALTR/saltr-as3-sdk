/**
 * Created by daal on 6/24/15.
 */
package saltr.repository {

public class RepositoryStorageManager {

    private var _repository:ISLTRepository;

    public function RepositoryStorageManager(repository:ISLTRepository) {
        _repository = repository;
    }


}
}
