import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../model/account.dart';
import '../../model/account_role.dart';
import '../../model/store.dart';
import '../../utils/sp_helper.dart';


abstract class UserRepository{
  Future<List<AccountRole>> fetchAccountRoles();
  Future<AccountRole> fetchAccountRole(int id);
  Future<dynamic> updateAccountRole(AccountRole accountRole);
  Future<Account> fetchUser();
  Future<dynamic> createUser(String name);
  Future<dynamic> deleteUser(String id);
  Future<Map<AccountRole,Store>> enter(int? storeId);
  Future<String> checkId(String accountId);
  Future<dynamic> createEmployee(AccountRole accountRole);
}

class UserRepositoryImpl implements UserRepository {
  SPHelper helper = SPHelper();

  //String base = 'http://10.0.2.2:8088';
  String base = 'https://sidam-scheduler.link';

  @override
  Future<List<AccountRole>> fetchAccountRoles() async {

    await helper.init();
    log(helper.getJWT());

    String apiUrl = '$base/api/employees/${helper.getStoreId()}';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        log("fetchAccountRoles.response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        print('Users got successfully.');
        List<AccountRole> accountRoles = [];
        for (var item in decodedData['data']) {
          accountRoles.add(AccountRole.fromJson(item));
        }
        return accountRoles;
      } else {
        log("response = ${response.body}");
        throw Exception('Failed to get user.');
      }
    } catch (e){
      log("error $e");
      throw Exception('Failed to get user. Error: $e');
    }
  }

  @override
  Future<AccountRole> fetchAccountRole(int employeeId) async {

    String apiUrl = '$base/api/employee/${helper.getStoreId()}/account?id=$employeeId';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        print('User got successfully.');

        AccountRole accountRole = AccountRole.fromJsonWithAccount(decodedData['data']['accountRole']);
        return accountRole;
      } else {
        log("response = ${response.body}");
        throw Exception('Failed to get user.');
      }
    } catch (e){
      log("error $e");
      throw Exception('Failed to get user. Error: $e');
    }
  }

  @override
  Future updateAccountRole(AccountRole accountRole) async {
    SPHelper helper = SPHelper();

    String apiUrl = '$base/api/employee/${helper.getStoreId()}?id=${accountRole.id!}';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(accountRole.toJson()),
      );

      if (response.statusCode == 200) {
        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        log("decodedData = $decodedData");
        print('User update successfully.');
      } else {
        throw Exception('Failed to update user.');
      }
    } catch (e) {
      throw Exception('Failed to update user. Error: $e');
    }
  }

  @override
  Future<Account> fetchUser() async {
    SPHelper helper = SPHelper();

    String apiUrl = '$base/member';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        print('User got successfully.');
        Account account = Account.fromJson(decodedData['data']);
        // helper.writeAlias(account.name!);
        return account;
      } else {
        log("response = ${response.body}");
        if(response.body == "UNAUTHORIZED"){
          log("UNAUTHORIZED");
          helper.writeJWT("");
          helper.writeIsLoggedIn(false);
        }
        helper.writeIsLoggedIn(false);
        throw Exception('Failed to get user.');
      }
    } catch (e){
      throw Exception('Failed to get user. Error: $e');
    }
  }

  @override
  Future<void> createUser(String name) async{
    SPHelper helper = SPHelper();

    print(helper.getJWT());

    String apiUrl = '$base/member/regist';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(<String, Object>{
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        helper.writeAlias(name);
        print("response.statusCode : 200, name : $name");
        helper.writeIsRegistered(true);
        print('User created successfully.');
      } else {
        throw Exception('Failed to create user.');
      }
    } catch (e) {
      throw Exception('Failed to create user. Error: $e');
    }
  }

  @override
  Future deleteUser(String id) {
    throw UnimplementedError();
  }



  @override
  Future<Map<AccountRole,Store>> enter(int? storeId) async {
    print("enter ${helper.getJWT()}");
    storeId ??= helper.getStoreId();

    String apiUrl = '$base/api/enter/$storeId';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};
    try {

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {

        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        log("decodedData2 = $decodedData");
        log('enter successfully.');

        AccountRole accountRole =AccountRole.fromJson(decodedData['data']['accountRole']);
        helper.writeRoleId(accountRole.id!);
        Store store = Store.fromJson(decodedData['data']['store']);
        helper.writeStoreName(store.name!);
        helper.writeStoreId(store.id!);
        return {accountRole : store};
      } else {

        log("response = ${response.body}");
        throw Exception('Failed to get user.');
      }
    } catch (e){
      log("error $e");
      throw Exception('Failed to get user. Error: $e');
    }
  }

  @override
  Future<Account> fetchUserWithId(int id) async {
    SPHelper helper = SPHelper();

    String apiUrl = '$base/member';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        print('User got successfully.');
        Account account = Account.fromJson(decodedData['data']);
        // helper.writeAlias(account.name!);
        return account;
      } else {
        log("response = ${response.body}");
        if(response.body == "UNAUTHORIZED"){
          log("UNAUTHORIZED");
          helper.writeJWT("");
          helper.writeIsLoggedIn(false);
        }
        helper.writeIsLoggedIn(false);
        throw Exception('Failed to get user.');
      }
    } catch (e){
      throw Exception('Failed to get user. Error: $e');
    }
  }

  @override
  Future<String> checkId(String accountId) async {
    SPHelper helper = SPHelper();

     String apiUrl = '$base/api/auth/check_duplication_id?accountId=$accountId';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);

        String message = decodedData['message'];
        String statusCode = decodedData['status_code'];

        log(statusCode);
        return statusCode;
      } else {

        throw Exception('Failed to get duplicate.');
      }
    } catch (e){
      throw Exception('Failed to get duplicate. Error: $e');
    }
  }

  @override
  Future<dynamic> createEmployee(AccountRole accountRole) async{
    SPHelper helper = SPHelper();

    String apiUrl = '$base/api/store/${helper.getStoreId()}/register/employee';
    final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(accountRole.toJsonWithAccount()),
      );

      if (response.statusCode == 200) {
        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        log("decodedData = $decodedData");
        print('User update successfully.');
      } else {
        throw Exception('Failed to update user.');
      }
    } catch (e) {
      throw Exception('Failed to update user. Error: $e');
    }
  }

  Future<dynamic> clearEmployee(int employeeId) async {

    SPHelper helper = SPHelper();
    await helper.init();

    String apiUrl = '$base/api/employees/$employeeId/clear';
    final headers = {
      'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json; charset=utf-8'
    };

    log(apiUrl);

    try {
      final res = await http.get(
        Uri.parse(apiUrl),
        headers: headers
      );

      if (res.statusCode == 200) {
        log('User account clear successfully.');
      } else {
        log('User account clear failed.');
        throw Exception('status code ${res.statusCode}');
      }
    } catch(e) {
      throw Exception('Failed to clear user account. Error: $e');
    }
  }

}
