import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';
import '../model/account_role.dart';



class ChattingViewModel extends ChangeNotifier{
  UserRepository userRepository;
  List<AccountRole> accountRole =[];

  ChattingViewModel(this.userRepository){
    loadData();
  }

  Future<void> loadData() async {
    try {
      final UserRole = await userRepository.fetchAccountRoles();
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
      print(e);
    }
  }
}