import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';

import '../model/account_role.dart';
import '../model/store.dart';
import '../utils/sp_helper.dart';

class StoreListViewModel extends ChangeNotifier{
  List<Store>? _storeList;
  StoreRepository _storeRepository;
  UserRepository _userRepository;
  ScrollController? _scrollController;
  Store? _store;
  AccountRole? _accountRole;
  DateTime? _updatedAt;

  StoreListViewModel(this._storeRepository, this._userRepository){
    enterStore(null);
  }

  get updatedAt => _updatedAt;
  get scrollController => _scrollController;
  List<Store>? get storeList => _storeList;
  Store? get store => _store;
  AccountRole? get accountRole => _accountRole;
  getMyStoreList() async{
    try {
      log("getMyStoreList");
      _storeList = await _storeRepository.fetchMyStoreList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> enterStore(int? storeId) async{
    try{
      Map<AccountRole, Store> user = await _userRepository.enter(storeId);
      user.keys.forEach((element) {
        _accountRole = element;
      });
      user.values.forEach((element) {
        _store = element;
      });
      log("enterStore._accountRole.name : ${_accountRole!.alias}");
      log("enterStore._store.name : ${_store!.name}");
      _updatedAt = DateTime.now();
      notifyListeners();
    }catch(e){
      throw e;
    }
  }
}
