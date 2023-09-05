import 'dart:convert';
import 'dart:developer';

import 'package:sidam_storemanager/model/anniversary.dart';

import '../../utils/sp_helper.dart';
import 'package:http/http.dart' as http;

abstract class AnniversaryRepository{
  Future fetchAnniversaries(int employeeId);
  Future fetchAnniversary(int anniversaryId);
  Future postAnniversary(Anniversary anniversary, int employeeId);
  Future putAnniversary(Anniversary anniversary);
  Future deleteAnniversary(int id);
}


class AnniversaryRepositoryImpl implements AnniversaryRepository{

  String anniversaryApi = 'http://10.0.2.2:8088/api/stores';
  SPHelper helper = SPHelper();

  @override
  Future fetchAnniversaries(int employeeId) async {
    final String apiUrl = '$anniversaryApi/${helper.getStoreId()}/employees/$employeeId/anniversary';

    log("fetchAnniversaries $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      List<Anniversary> anniversaryList = [];
      for (var item in decodedData['data']) {
        anniversaryList.add(Anniversary.fromJson(item));
      }
      log("${anniversaryList.length}");
      log('NoticeList get successfully.');
      return anniversaryList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future fetchAnniversary(int id) {
    throw UnimplementedError();
  }

  @override
  Future postAnniversary(Anniversary anniversary, int employeeId) async {
    final String apiUrl = '$anniversaryApi/${helper.getStoreId()}'
        '/employees/$employeeId/anniversary';

    log("postAnniversary $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};


    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(anniversary.toJson()),
    );

    if (response.statusCode == 200) {

      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      log('postAnniversary done successfully.');
      return decodedData['id'];
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future putAnniversary(Anniversary anniversary) {
    throw UnimplementedError();
  }

  @override
  Future deleteAnniversary(int id) async {
    final String apiUrl = '$anniversaryApi/${helper.getStoreId()}'
        '/employees/0/anniversary/$id';

    log("postAnniversary $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};


    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {

      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);

      log('postAnniversary done successfully.');
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

}