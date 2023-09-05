import 'package:sidam_storemanager/data/repository/store_repository.dart';

import '../../model/store.dart';

class MockStoreRepository implements StoreRepository{
  @override
  Future<void> createStore(Store store) async{
    print("createStore : ${store.toJson()}");
  }

  @override
  Future deleteStore(String id) {
    throw UnimplementedError();
  }

  @override
  Future getStore(String param1) async {
    dynamic mockData = {
      'id': param1,
      'name': '가게이름',
      'location' : '가게위치',
      'phone':'010-0000-0000',
      'open':'10:00',
      'close':'23:00',
      'costPolicy':'costPolicy',
      'payday':'10일',
    };
    return mockData;
  }

  @override
  Future<List> geCostPolicies() async {

    throw UnimplementedError();
  }



  @override
  Future<void> updateStore(Store store) async {
  print("updateStore : ${store.toJson()}");
  }

  @override
  Future<String> fetchSearchedStores(String search) {
    throw UnimplementedError();
  }

  @override
  Future<String> fetchStores() {
    throw UnimplementedError();
  }

  @override
  Future<StoreList> getAllStores() {
    throw UnimplementedError();
  }

  @override
  Future<StoreList> getStores(String search) {
    throw UnimplementedError();
  }

  @override
  Future<Store> fetchStore(int? storeId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Store>> fetchMyStoreList() {
    throw UnimplementedError();
  }

  @override
  Future<Store> fetchStoreById(int storeId) {
    throw UnimplementedError();
  }
}