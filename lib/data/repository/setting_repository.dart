import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../utils/sp_helper.dart';

class SettingRepository{
  SPHelper helper = SPHelper();

  Future<void> logout() async {
    helper.remove('jwt');
    helper.remove('isLoggedIn');
    const String apiUrl = 'https://kauth.kakao.com/oauth/logout';
    final headers = {'Authorization': 'Bearer '+helper.getJWT(),
      'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log('logout success : ${response.body}');

    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      log('fia');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }
  void withdrawal(){

  }
}