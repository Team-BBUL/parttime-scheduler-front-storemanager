import 'package:sidam_storemanager/data/repository/user_repository.dart';
import 'package:sidam_storemanager/model/account.dart';
import 'package:sidam_storemanager/model/store.dart';

import '../../model/account_role.dart';


class FixedUserRepositoryStub extends UserRepository{

  @override
  Future<List<AccountRole>> getUsers() async {
    List<dynamic> testData = [
      {
        "user_role_id" : "1",
        "kakao_id" : "test1",
        "alias" : "홍길동",
        'level': "매니저",
        "cost": "9600",
        "color" : "red",
        "isSalary" : false,
        'valid': false,
      },
      {
        "user_role_id" : "2",
        "kakao_id" : "test2",
        "alias" : "성춘향",
        'level': "직원",
        "cost": "9600",
        "color" : "red",
        "isSalary" : false,
        'valid': false,

      },
      {
        "user_role_id" : "3",
        "kakao_id" : "test3",
        "alias" : "이아무개",
        'level': "아르바이트",
        "cost": "9600",
        "color" : "red",
        "isSalary" : false,
        'valid': false,
      }
    ];
    List<AccountRole> users = testData.map((json) => AccountRole.fromJson(json)).toList();
    return users;
  }

  @override
  Future deleteUser(String id) {
    throw UnimplementedError();
  }

  @override
  Future createUser(String kakaoId) {
    throw UnimplementedError();
  }

  @override
  Future<Account> getUser() {
    throw UnimplementedError();
  }

  @override
  Future<Account> fetchUser() {
    throw UnimplementedError();
  }

  @override
  Future<List<AccountRole>> fetchUsers() {
    throw UnimplementedError();
  }

  @override
  Future<AccountRole> fetchAccountRole(int storeId) {
    throw UnimplementedError();
  }

  @override
  Future<List<AccountRole>> fetchAccountRoles() {
    throw UnimplementedError();
  }


  @override
  Future updateAccountRole(AccountRole accountRole) {
    throw UnimplementedError();
  }

  @override
  Future<Map<AccountRole, Store>> enter(int? storeId) {
    throw UnimplementedError();
  }


}