
import 'package:flutter/cupertino.dart';
import 'package:sidam_storemanager/model/account_data.dart';
import 'package:sidam_storemanager/utils/sp_helper.dart';

import '../data/repository/account_repository.dart';

class RegisterViewModel extends ChangeNotifier {

  late final AccountRepository _accountRepository;
  AccountData login = AccountData(accountId: '', password: '', role: 'MANAGER');
  final SPHelper _helper = SPHelper();

  bool loading = false; // 회원가입 전송하고 대기중
  bool success = false; // 회원가입 성공 여부
  String message = ''; // 회원가입 성공/실패 메시지

  RegisterViewModel() {
    _helper.init();
    _accountRepository = AccountRepository();
  }

  // 회원가입 메소드
  Future<void> fetchRegister(String id, String pw) async {
    if (!loading){
      loading = true;

      login.accountId = id;
      login.password = pw;

      message = await _accountRepository.signup(login);
      if (message.contains('성공')) {
        success = true;
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        loading = false;
        notifyListeners();
      });
    }
  }
}