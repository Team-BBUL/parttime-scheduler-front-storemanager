import 'dart:convert';
import 'dart:developer';

import 'package:sidam_storemanager/data/repository/schedule_local_repository.dart';

import '../../model/schedule.dart';
import '../../utils/sp_helper.dart';

import 'package:http/http.dart' as http;


abstract class ScheduleRemoteRepository {
  Future<MonthSchedule> fetchSchedule(String timeStamp, int year, int month, int day);
}

class ScheduleApiRepository implements ScheduleRemoteRepository{

  String scheduleApi = 'http://10.0.2.2:8088/api/schedule';

  @override
  Future<MonthSchedule> fetchSchedule(String timeStamp, int year, int month, int day) async {
    SPHelper helper = SPHelper();

    final String apiUrl = '$scheduleApi/${helper.getStoreId()}?id=${helper.getRoleId()}&version=$timeStamp&year=$year&month=$month&day=$day';

    log("fetchSchedule $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      if(decodedData['time_stamp'] == timeStamp){
        print('스케줄 버전이 최신입니다..');
        return MonthSchedule();
      }else{
        ScheduleLocalRepository().saveSchedule(decodedData, timeStamp);
      }
      return MonthSchedule.fromJson(decodedData);
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }


}

