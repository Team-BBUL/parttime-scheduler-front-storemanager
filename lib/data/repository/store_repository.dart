import 'dart:convert';
import 'dart:developer';


import '../../model/store.dart';
import '../../utils/sp_helper.dart';
import 'package:http/http.dart' as http;

abstract class StoreRepository{
  Future<Store> fetchStore(int? storeId);
  Future<List<dynamic>> geCostPolicies();
  Future<dynamic> createStore(Store store);
  Future<void> updateStore(Store store);
  Future<dynamic> deleteStore(String id);
  Future<String> fetchSearchedStores(String search);
  Future<String> fetchStores();
  Future<List<Store>> fetchMyStoreList();

}

class StoreRepositoryImpl implements StoreRepository{
  static String storeApi = 'http://10.0.2.2:8088/store';
  static SPHelper helper = SPHelper();
  final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
    'Content-Type': 'application/json'};

  @override
  Future<Store> fetchStore(int? storeId) async{
    log("fetchAnnouncementHelperHash: ${helper.hashCode}");

    if(_isSameStore(storeId)) {
      return Store();
    }
    if(_isIdsNull(storeId)){
      return Store();
    }else{
      storeId = helper.getStoreId();
    }

    log('$storeId');
    log('${helper.getStoreId()}');

    helper.init();

    final String apiUrl = '$storeApi/$storeId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = json.decode(response.body);
      Map<String, dynamic> storeData = decodedData['data'];
      Store store = Store.fromJson(storeData);
      helper.writeStoreId(store.id!);
      helper.writeStoreName(store.name!);
      helper.writeIsRegistered(true);
      log('fetchStore.helper.getCurrentStoreId" = ${helper.getStoreId()}');
      log('Store get successfully.');
      return store;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future<dynamic> createStore(Store store) async{
    helper.init();
    final String apiUrl = '$storeApi/regist';
    log("createStore ${headers}");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(store.toJson()),
    );
    if (response.statusCode == 200) {
      helper.writeIsRegistered(true);
      helper.writeStoreName(store.name!);
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      helper.writeStoreId(decodedData['store_id']);
      log('store_repository.helper.getCurrentStoreId" = ${helper.getStoreId()}');
      log('Post created successfully.');
      return decodedData['status_code'];
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future deleteStore(String id) {
    // TODO: implement deleteStore
    throw UnimplementedError();
  }

  @override
  Future<String> fetchSearchedStores(String search) {
    // TODO: implement fetchSearchedStores
    throw UnimplementedError();
  }

  @override
  Future<String> fetchStores() {
    // TODO: implement fetchStores
    throw UnimplementedError();
  }

  @override
  Future<List> geCostPolicies() {
    // TODO: implement geCostPolicies
    throw UnimplementedError();
  }


  @override
  Future<void> updateStore(Store store) {
    // TODO: implement updateStore
    throw UnimplementedError();
  }

  @override
  Future<List<Store>> fetchMyStoreList() async{
    helper.init();
    final String apiUrl = '$storeApi/my-list?role=MANAGER';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    log("fetchMyStoreList");
    if (response.statusCode == 200) {
      log("request success");
      List<Store> storeList = [];
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      for (var item in decodedData["data"]) {
        storeList.add(Store.fromJson(item));
      }
      return storeList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    } else{
      log('failed : ${response.body}');

      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  bool _isSameStore(int? storeId) {
    int? currentStoreId = helper.getStoreId();
    if(currentStoreId != null && currentStoreId == storeId){
      return true;
    }
    return false;
  }

  bool _isIdsNull(int? storeId) {
    if(storeId == null){
      storeId = helper.getStoreId();
      if(storeId == null){
        return true;
      }
    }
    return false;
  }



}
