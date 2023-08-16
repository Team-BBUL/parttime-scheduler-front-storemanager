import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';

import '../model/store.dart';

class StoreListViewModel extends ChangeNotifier{
  List<Store>? _storeList;
  StoreRepository _storeRepository;
  ScrollController? _scrollController;

  StoreListViewModel(this._storeRepository);

  get scrollController => _scrollController;
  get storeList => _storeList;

  getMyStoreList() async{
    try {
      log("getMyStoreList");
      _storeList = await _storeRepository.fetchMyStoreList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  enterStore(int storeId) async{
    try{
      log("enterStore");
      await _storeRepository.fetchStore(storeId);
    }catch(e){
      throw e;
    }
  }
}