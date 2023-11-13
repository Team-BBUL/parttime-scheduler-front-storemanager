import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../model/schedule_model.dart';
import '../local_data_source.dart';
import '../remote_data_source.dart';
import '../../utils/sp_helper.dart';
import '../../utils/date_utility.dart';

class ScheduleRepository{

  final LocalDataSource _dataSource = LocalDataSource();
  final Session _session = Session();
  final _logger = Logger();
  final _helper = SPHelper();

  // 서버에서 데이터를 불러와서 로컬에 저장하는 메소드
  Future<void> getWeeklySchedule(DateTime now) async {

    DateTime getDate = DateUtility.findStartDay(now, _helper.getWeekStartDay() ?? 1);

    _logger.i('${getDate.month}월 ${getDate.day}일 데이터 요청');

    // 서버에 요청
    var url = '/api/schedule/${_helper.getStoreId()}'
        '?id=${_helper.getRoleId()}&version=${DateFormat("yyyy-MM-ddThh:mm:ss").format(DateTime(2023, 01, 01))}'
        '&year=${getDate.year}&month=${getDate.month}&day=${getDate.day}';

    var res = await _session.get(url);

    // json 저장 형식으로 변환해서 객체로 돌려받음
    var saveData = _restructureSchedule(jsonDecode(res.body), getDate);

    // 받아온 스케줄 정보가 없을 경우 저장하지 않고 종료
    if (saveData.isEmpty) {
      _logger.w('${getDate.month}월 ${getDate.day}일에 스케줄이 존재하지 않습니다.');
      return ;
    }

    /*
    _logger.i('${_dataSource.path}에 json 저장');

    _dataSource.saveModels({
      "date": saveData.map<Map<String, dynamic>>((value) => value.toJson()).toList()
    }, 'schedules/scheduleDataSaveTest.json'); // -> 정상 동작, 제대로 파일 불러와서 저장됨
    */

    // 이미 저장된 파일이 있는 경우 -> 불러와서 합치는 과정을 거치고 저장
    _getSave(saveData, getDate);
  }

  // 만약 다음달/이전달과 이번달이 한 주로 받아와졌다면 둘로 쪼개서 저장
  Future<void> _getSave(List<ScheduleList> data, DateTime base) async {

    DateFormat nameFormat = DateFormat("yyyyMM");
    DateTime thisDate = DateTime(base.year, base.month, 1); // 이번달 1일
    DateTime lastDate = DateTime(thisDate.year, thisDate.month - 1, 1).subtract(const Duration(days: 1)); // 저번달 1일
    DateTime nextDate = DateTime(thisDate.year, thisDate.month + 1, 1); // 다음달 1일

    List<ScheduleList> thisMonthSchedule = [];
    List<ScheduleList> lastMonthSchedule = [];
    List<ScheduleList> nextMonthSchedule = [];

    for (var schedule in data) {
      if (schedule.day.month == thisDate.month) {
        thisMonthSchedule.add(schedule);
      }
      else if (schedule.day.month == lastDate.month){
        lastMonthSchedule.add(schedule);
      }
      else {
        nextMonthSchedule.add(schedule);
      }
    }

    // 이번달 데이터 저장 - json -> ScheduleList로 변환해서 전달하기
    if (thisMonthSchedule.isNotEmpty) {
      _combineAndSaveSchedule(
          _localToScheduleList(
              await _dataSource.getSchedule(thisDate)),
          thisMonthSchedule,
          nameFormat.format(thisDate)
      );
    }

    // 지난달 데이터 저장
    if(lastMonthSchedule.isNotEmpty) {
      _combineAndSaveSchedule(
          _localToScheduleList(await _dataSource.getSchedule(lastDate)),
          lastMonthSchedule,
          nameFormat.format(lastDate)
      );
    }

    // 다음달 데이터 저장
    if(nextMonthSchedule.isNotEmpty) {
      _combineAndSaveSchedule(
          _localToScheduleList(await _dataSource.getSchedule(nextDate)),
          nextMonthSchedule,
          nameFormat.format(nextDate)
      );
    }
  }

  // 로컬에 저장되어있던 json을 ScheduleList 형으로 변환
  List<ScheduleList> _localToScheduleList(Map<String, dynamic> json) {

    List<ScheduleList> result = [];

    // 오류 등으로 'date'가 없는 경우 변환 X
    if (json['date'] == null || json['date'] == 'NON') {
      return [];
    }

    // 날짜별 스케줄 블록들을 확인
    for (var date in json['date']) {

      if (date == null) { continue; }

      List<Schedule> schedules = [];
      List<String> stringDay = date['day'].split('-');
      DateTime day = DateTime(int.parse(stringDay[0]), int.parse(stringDay[1]), int.parse(stringDay[2]));

      // 날짜 하나에 붙어있는 블록을 각각 쪼개서 Schedule 객체화
      for (var schedule in date['schedule']) {
        Schedule tmp = Schedule.fromJson(schedule, day);
        schedules.add(tmp);
      }

      ScheduleList temp = ScheduleList(id: date['id'], day: day, schedule: schedules);
      result.add(temp);
    }

    return result;
  }

  // 이미 저장되어있던 파일(saved)을 읽어와서 서버에서 새로 get한 데이터(bring)와 합치고 fileName이란 이름으로 저장
  void _combineAndSaveSchedule(List<ScheduleList> saved, List<ScheduleList> bring, String fileName) {

    bring.sort((a, b) => a.day.compareTo(b.day));

    int last = (bring.length - 1) < 0 ? 0 : bring.length - 1;
    DateTime start = bring[0].day.subtract(const Duration(days: 1)); // 스케줄 시작일 - 1
    DateTime end = bring[last].day.add(const Duration(days: 1));

    // 서버에서 가져온 데이터와 겹치는 데이터 삭제
    saved.removeWhere((element) => element.day.isAfter(start) && element.day.isBefore(end));
    saved.addAll(bring);

    _dataSource.saveModels({
      "date": saved.map<Map<String, dynamic>>((value) => value.toJson()).toList()
    }, 'schedules', fileName);
  }

  // 서버에서 받은 json을 ScheduleList 형으로 변환
  List<ScheduleList> _restructureSchedule(Map<String, dynamic> json, DateTime startDay) {

    List<ScheduleList> list = [];
    List<DateTime> date = [];
    List<Schedule> scheduleList = [];

    if (json['date'] == null) {
      return list;
    }

    for(var schedule in json['date']) {
      List<String> parseDay = '${schedule['day']}'.split('-');
      DateTime day = DateTime(int.parse(parseDay[0]), int.parse(parseDay[1]), int.parse(parseDay[2]));
      Schedule tmp = Schedule.fromJson(schedule, day);

      // day가 시작일자 -1 이후이면 리스트에 추가
      if (day.isAfter(startDay.subtract(const Duration(days: 1))) ) {
        // && day.isBefore(startDay.subtract(const Duration(days: 7)))){
        scheduleList.add(tmp);
      }

      if (!date.contains(day)) {
        date.add(day);
      }
    }

    int i = 1;
    for (DateTime time in date) {
      list.add(_combineSameDay(scheduleList, i, time));
      i++;
    }

    return list;
  }

  // 날짜별로 합치기
  ScheduleList _combineSameDay(List<Schedule> data, int idx, DateTime base) {

    List<Schedule> schedules = [];

    for (Schedule schedule in data) {
      if (schedule.day == base) {
        schedules.add(schedule);
      }
    }

    return ScheduleList(id: idx, day: base, schedule: schedules);
  }

  // 로컬에서 오늘 스케줄을 모두 읽어오는 메소드
  Future<List<ViewSchedule>> loadTodaySchedule(DateTime now) async {

    var thisMonthSchedule = await _dataSource.getSchedule(now);

    return fromJsonSchedule(thisMonthSchedule, now);
  }

  // 읽어온 json을 ViewSchedule 형식으로 변형하는 메소드
  List<ViewSchedule> fromJsonSchedule(Map<String, dynamic> data, DateTime now) {

    // 데이터가 없을 경우
    if (data['date'] == null || data['date'] == 'NON') {
      _logger.i('${DateFormat('yyyy년 MM월 dd일').format(now)} 데이터 존재하지 않음');
      return [];
    }

    // 혹시 모르니까 시각 정보 삭제
    DateTime today = DateTime(now.year, now.month, now.day);
    List<ViewSchedule> result = [];


    // 있으면 변환
    for (var day in data['date']) {

      if(day == null) { break; }

      List<String> days = day['day'].split('-');
      DateTime thisDay = DateTime(int.parse(days[0]), int.parse(days[1]), int.parse(days[2]));

      // 오늘 날짜가 맞으면
      if (thisDay == today) {

        for (var daily in day['schedule']) {
          Schedule schedule = Schedule.fromJson(daily, thisDay);
          result.addAll(schedule.toViewSchedule());
        }
      }
    }

    return result;
  }
}