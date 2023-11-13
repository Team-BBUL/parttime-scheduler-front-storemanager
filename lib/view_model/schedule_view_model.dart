import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';

import 'package:sidam_storemanager/data/repository/schedule_repository.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/model/schedule_model.dart';
import 'package:sidam_storemanager/model/store.dart';
import 'package:sidam_storemanager/utils/date_utility.dart';
import 'package:sidam_storemanager/utils/sp_helper.dart';

class ScheduleViewModel extends ChangeNotifier {
  final _logger = Logger();

  late final ScheduleRepository _scheduleRepository;
  late final StoreRepositoryImpl _storeRepository;
  late final SPHelper _helper;

  List<ViewSchedule> _todaySchedule = []; // 오늘 전 근무자의 근무표
  List<ViewSchedule> get today => _todaySchedule;

  DateTime _week = DateTime.now(); // 주 시작일
  DateTime get week => _week;

  Store _store = Store();
  Store get store => _store;

  bool _monthly = false;
  void initMonthly() {
    _monthly = false;
  }

  ScheduleViewModel() {
    _scheduleRepository = ScheduleRepository();
    _storeRepository = StoreRepositoryImpl();
    _helper = SPHelper();
    _helper.init();

    init();
    _getScheduleList();
  }

  void init() async {
    await _helper.init();
    getStore();
    _week = DateUtility.findStartDay(DateTime.now(), _helper.getWeekStartDay() ?? 1);
  }

  // 새로고침을 누르면 스케줄을 새로 가지고 올 메소드
  Future<void> renew() async {
    _todaySchedule = [];
    await _getScheduleList();
    notifyListeners();
  }

  // 화면에 그릴 스케줄을 가지고 오는 메소드
  Future<void> _getScheduleList() async {

    try{ // 서버에서 읽어오는 부분에서 오류가 나도 이후 코드를 실행하도록
      if (!_monthly) {
        _getMonthSchedule(); // _week로 부터 4주 치 데이터 가져옴
      }
      _scheduleRepository.getWeeklySchedule(DateTime.now()); // 서버에서 데이터 가져옴

    } catch(error) {
      _logger.e('$error');
    }

    // 로컬에서 데이터 읽어오기
    _todaySchedule = await _scheduleRepository.loadTodaySchedule(DateTime.now());

    notifyListeners();
  }

  // 이번 주로부터 4주차 이전까지의 데이터를 가지고 오는 메소드
  Future<void> _getMonthSchedule() async {

    DateTime now = DateTime.now();
    DateTime start = DateUtility.findStartDay(now, _helper.getWeekStartDay() ?? 1);
    DateTime thisWeek = start;

    for (int i = 1; i <= 4; i++) {
      thisWeek = thisWeek.subtract(const Duration(days: 7));
      await _scheduleRepository.getWeeklySchedule(thisWeek);
    }
    _monthly = true;
  }

  // 서버에서 데이터 가져오는 메소드
  Future getScheduleData() async {
    if (!_monthly) {
      _getMonthSchedule();
    }
    _scheduleRepository.getWeeklySchedule(DateTime.now()); // 서버에서 데이터 가져옴
  }

  Future getStore() async {
    _store = await _storeRepository.loadStore();
  }
}