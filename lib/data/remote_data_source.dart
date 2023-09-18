import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:sidam_storemanager/utils/sp_helper.dart';

class Session {

  Future init() async {
    await _helper.init();

    _accountRoleId = _helper.getRoleId() ?? 0;
    headers['Authorization'] = 'Bearer ${_helper.getJWT()}';
  }

  var logger = Logger();
  static final SPHelper _helper = SPHelper();

  //final String _server = "http://10.0.2.2:8088"; // 서버의 주소
  final String _server = "https://sidam-scheduler.link"; // 서버의 주소
  int _accountRoleId = _helper.getRoleId() ?? 0; // 현재 클라이언트의 사용자 ID

  set setRoleId(int id) { _accountRoleId = id; }
  get roleId { return _accountRoleId; }
  get server { return _server; }

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_helper.getJWT()}',
  };

  Map<String, String> cookies = {};

  // url = '/api/store/data' 와 같은 형식으로 전달
  Future<http.Response> get(String url) async {
    logger.i("get - $url");
    http.Response response =
    await http.get(Uri.parse('$server$url'), headers: headers);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400) {
      logger.w('$url\nget warning\n${response.body}');
    }
    return response;
  }

  // url = '/api/store/data' 와 같은 형식으로 전달
  Future<http.Response> post(String url, dynamic data) async {
    logger.i("post - $url, ${data.toString()}");
    http.Response response =
    await http.post(Uri.parse('$server$url'),
        body: jsonEncode(data), headers: headers);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400) {
      logger.w('$url\npost warning\n${response.body}');
    }

    return response;
  }

  // url = '/api/store/data' 와 같은 형식으로 전달
  Future<http.Response> delete(String url) async {
    logger.i("delete - $url");
    http.Response response =
    await http.delete(Uri.parse('$server$url'),
        headers: headers);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400) {
      logger.w('$url\ndelete warning\n${response.body}');
    }

    return response;
  }

  Future<http.Response> put(String url, dynamic data) async {
    logger.i('put - $url');
    http.Response response =
        await http.put(Uri.parse('$server$url'),
        body: jsonEncode(data), headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 400) {
      logger.w('$url\nput warning\n${response.body}');
    }

    return response;
  }
}