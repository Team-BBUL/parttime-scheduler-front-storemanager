abstract class StoreRepository{
  Future<List<dynamic>> getStores();
  Future<dynamic> getStore(String id);
  Future<List<dynamic>> geCostPolicies();
  Future<dynamic> createStore(Map<String, dynamic> store);
  Future<dynamic> updateStore(Map<String, dynamic> store);
  Future<dynamic> deleteStore(String id);
}