import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/model/store.dart';
import 'package:sidam_storemanager/data/model/user_role.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';

class StoreManagementViewModel extends ChangeNotifier{
  StoreRepository storeRepository;
  UserRepository userRepository;
  Store store = Store(id: '',location: '', name: '', phone: '', open: '', close: '', costPolicy: '', payday: '', );
  List<UserRole> userRole =[];
  StoreManagementViewModel(this.storeRepository,this.userRepository){
    loadUsers();
    loadStore();
  }
  Future<void> loadStore() async {
    try {
      final result = await storeRepository.getStore("test");

      store = Store.fromJson(result);
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
      print("test");
      print(e);
    }
  }

  Future<void> loadUsers() async {
    try {
      final result = await userRepository.getUsers();
      userRole = result.map((json) => UserRole.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
      print(e);
    }
  }

}
