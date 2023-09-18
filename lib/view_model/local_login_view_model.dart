import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sidam_storemanager/data/repository/store_repository.dart';

import 'package:sidam_storemanager/model/account_data.dart';
import 'package:sidam_storemanager/model/account_role.dart';
import 'package:sidam_storemanager/utils/sp_helper.dart';

import '../data/repository/account_repository.dart';

class LocalLoginViewModel extends ChangeNotifier {

  late final AccountRepository _loginRepository;
  late final StoreRepository _storeRepository;
  AccountData login = AccountData(accountId: '', password: '', role: 'MANAGER');
  AccountRole account = AccountRole();
  final SPHelper _helper = SPHelper();

  bool loading = false; // api를 보내고 기다리는 중인지 확인
  bool success = false; // 로그인 api의 성공/실패 여부
  bool init = false; // 회원 정보 등록 여부
  bool updateLoading = false; // 회원정보 등록 전송 중인지 확인
  bool inStore = false; // 매장이 있는 회원인지 확인
  String message = '';

  LocalLoginViewModel() {
    _helper.init();
    _loginRepository = AccountRepository();
    _storeRepository = StoreRepositoryImpl();
  }

  Future<void> getAccountRole() async {
    if (account.id == null || account.id == 0){
      account = await _loginRepository.getAccountRole();
    }
  }

  Future<void> saveAccountRole() async {
    _loginRepository.saveAccountRole(account);
  }

  Future<void> fetchLogin(String id, String pw) async {
    if (!loading){
      loading = true;

      login.accountId = id;
      login.password = pw;

      http.Response res = await _loginRepository.login(login);
      inStore = false;
      init = false;

      if (res.statusCode == 200) {
        success = true;
        List<String> token = (res.headers['authorization'] ?? '').split(' ');
        _helper.writeJWT(token[1]); // 토큰 넣기
        _helper.writeIsLoggedIn(true); // 로그인 여부 true

        Map<String, dynamic> data = jsonDecode(res.body);
        log('$data');
        if (data['store'] == null) {
          inStore = false;
        } else {
          inStore = true;
        }
        init = data['user']['valid'] ?? false;
        _helper.writeStoreId(data['store'] ?? 0);
        _helper.writeRoleId(data['user']['id']);
        _helper.writeAlias(data['user']['alias'] ??'');

        account = AccountRole.fromJson(data['user']);
        log(account.toString());
        saveAccountRole();

      } else {
        success = false;
        message = jsonDecode(res.body)['message'];
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        loading = false;
        notifyListeners();
      });
    }
  }

  // 회원정보 등록 메소드
  Future<void> setAccountData(String name) async {
    if (success && !updateLoading) {
      updateLoading = true;

      account.alias = name;
      account.valid = true;
      account.salary = false;

      await _loginRepository.updateAccount(account);

      Future.delayed(const Duration(milliseconds: 1000), (){
        updateLoading = false;
        _helper.writeIsRegistered(true);
        _helper.writeAlias(name);
        notifyListeners();
      });
    }
  }

  Future getStoreData() async {
    _storeRepository.fetchStore(_helper.getStoreId());
  }
}