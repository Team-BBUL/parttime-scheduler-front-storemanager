import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/model/store.dart';

class StoreViewModel {

  late StoreRepositoryImpl _storeRepository;
  late Store _store;
  Store get store => _store;

  StoreViewModel() {
    _storeRepository = StoreRepositoryImpl();
  }

  Future<Store> getStore() async {
    _store = await _storeRepository.loadStore();
    return _store;
  }
}