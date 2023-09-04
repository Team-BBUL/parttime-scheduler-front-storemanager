import 'dart:convert';
import 'dart:developer';

import 'package:sidam_storemanager/model/cost_policy.dart';

import '../../utils/sp_helper.dart';
import 'package:http/http.dart' as http;



abstract class CostPolicyRepository{
  Future fetchAllPolicy();
  Future postPolicy(CostPolicy policy);
  Future deletePolicy(int policyId);
}

class CostPolicyRepositoryImpl implements CostPolicyRepository{
  SPHelper helper = SPHelper();

  String policyApi = 'http://10.0.2.2:8088/api/stores';

  @override
  Future fetchAllPolicy() async {
    final String apiUrl = '$policyApi/${helper.getStoreId()}/costpolicies';

    log("fetchAllPolicy $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      List<CostPolicy> policyList = [];
      if(decodedData['data'].isEmpty){
        return policyList;
      }
      for (var item in decodedData['data']['costPolicies']) {
        policyList.add(CostPolicy.fromJson(item));
      }

      log('fetchAllPolicy get successfully.');

      return policyList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{

      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future postPolicy(CostPolicy policy) async {

    final String apiUrl = '$policyApi/${helper.getStoreId()}/costpolicy}';

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    log("policy incentive  ${policy.toJson()}");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body:  jsonEncode(policy.toJson()),
    );

    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);

      log('postPolicy get successfully.');
      return decodedData['id'];
    } else if(response.statusCode == 400) {

      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future deletePolicy(int policyId) async {
    SPHelper helper = new SPHelper();

    final String apiUrl = '$policyApi/${helper.getStoreId()}/costpolicies/$policyId}';

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);

      log('deletePolicy get successfully.');
    } else if(response.statusCode == 400) {

      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }
}