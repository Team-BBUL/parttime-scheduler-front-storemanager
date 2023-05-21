import 'package:sidam_storemanager/data/repository/store_repository.dart';

class MockStoreRepository implements StoreRepository{
  @override
  Future createStore(Map<String, dynamic> store) {
    // TODO: implement createStore
    throw UnimplementedError();
  }

  @override
  Future deleteStore(String id) {
    // TODO: implement deleteStore
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
      'payday':'매월 10일',
    };
    return mockData;
  }

  @override
  Future<List> geCostPolicies() async {

    throw UnimplementedError();
  }

  @override
  Future<List> getStores() {
    // TODO: implement getStores
    throw UnimplementedError();
  }

  @override
  Future updateStore(Map<String, dynamic> store) {
    // TODO: implement updateStore
    throw UnimplementedError();
  }



}