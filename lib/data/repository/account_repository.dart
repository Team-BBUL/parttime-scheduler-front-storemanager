import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sidam_storemanager/data/local_data_source.dart';
import 'package:sidam_storemanager/data/remote_data_source.dart';
import 'package:sidam_storemanager/model/account_data.dart';
import 'package:sidam_storemanager/model/account_role.dart';

class AccountRepository{

  final LocalDataSource _dataSource = LocalDataSource();
  final Session _session = Session();
  String message = '';
  
  // 로그인 메소드
  Future<http.Response> login(AccountData ad) async {
    
    http.Response res = await _session.post('/api/auth/login', {
      'accountId': ad.accountId,
      'password': ad.password
    });

    return res;
  }

  // 회원가입
  Future<String> signup(AccountData ad) async {

    http.Response res = await _session.post('/api/auth/signup', ad.toJson());

    if (res.statusCode == 200) {
      return '회원가입에 성공했습니다';
    } else {
      return jsonDecode(utf8.decode(res.bodyBytes))['data'][0]['defaultMessage'];
    }
  }

  // 회원 정보 등록
  Future<bool> updateAccount(AccountRole role) async {

    await _session.init();
    http.Response res = await _session.put('/api/auth/account/details', role.toUpdateAccountJson());

    if (res.statusCode == 200) {
      return true;
    }
    message = res.body;
    return false;
  }

  // 회원 정보 불러오기
  Future<AccountRole> getAccountRole() async {
    Map<String, dynamic> json = await _dataSource.loadJson('userData');

    return AccountRole.fromJson(json);
  }

  // 회원 정보 저장
  Future<void> saveAccountRole(AccountRole role) async {

    _dataSource.saveModels(role.toJson(), '', 'userData');
  }
}