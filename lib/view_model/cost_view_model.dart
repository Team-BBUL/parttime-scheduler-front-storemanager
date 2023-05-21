import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';

import '../data/model/user_role.dart';

class CostViewModel extends ChangeNotifier{
  // CostRepository costRepository;
  UserRepository userRepository;
  List<UserRole> userRole =[];
  List<bool> isExpandedList = [];
  CostViewModel(this.userRepository){
    loadData();
  }
  void toggleItemSelection(int index) {
    print(isExpandedList[index]);
    isExpandedList[index] = !isExpandedList[index];
    notifyListeners();
  }

  Future<void> loadData() async {
    try {
      final result = await userRepository.getUsers();
      userRole = result.map((json) => UserRole.fromJson(json)).toList();
      isExpandedList = List.filled(userRole.length, false);
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
      print(e);
    }
  }
}