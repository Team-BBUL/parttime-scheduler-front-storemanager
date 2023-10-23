import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sidam_storemanager/data/repository/incentive_repository.dart';
import 'package:sidam_storemanager/data/repository/schedule_api_respository.dart';
import 'package:sidam_storemanager/model/Incentive.dart';

import '../data/repository/schedule_local_repository.dart';
import '../model/employee_cost.dart';
import '../model/schedule.dart';

class CostViewModel extends ChangeNotifier{
  final ScheduleLocalRepository _scheduleLocalRepository = ScheduleLocalRepository();
  final ScheduleRemoteRepository _scheduleRemoteRepository;
  final IncentiveRepository _incentiveRepository;
  final DateTime _now = DateTime.now();

  MonthSchedule? monthSchedule;
  MonthSchedule? thisWeekSchedule;
  List<MonthIncentive>? monthIncentives;

  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  List<EmployeeCost>? employeesCost;
  String? selectedDate;
  int? dateIndex;
  int costDay = 1;
  int totalWorkTime = 0;
  int pay = 0;
  int totalPay = 0;

  int prevMonthTotalPay = 0;
  bool customTileExpanded = false;
  get pickerYear => _pickerYear;
  get selectedMonth => _selectedMonth;

  CostViewModel(this._scheduleRemoteRepository, this._incentiveRepository){
    loadData();
  }

  Future<void> loadData() async {
    employeesCost = [];
    monthSchedule = null;
    try {
      log("----------------------------------------loadData-----------------------");
      await fetchLocalSchedule(_selectedMonth);
      await getMonthIncentive();
      await getCost();

    }catch(e){
      log("loadData $e");
    }
    notifyListeners();
  }

  getCost() async {
    log("getCost processing");
    await calculateEachCost();
    await calculateTotalCost();
    prevMonthTotalPay = await _scheduleLocalRepository.getPrevMonthCost(
        selectedMonth, costDay);
    notifyListeners();
  }

  getMonthIncentive() async{
    try {
      monthIncentives = await _incentiveRepository.fetchMonthIncentives(selectedMonth);
      log("getMonthIncentive success");
    }catch(e){
      log("getMonthIncentive error : $e");
    }
  }

  Future<String> fetchLocalSchedule(DateTime dateTime) async {

    monthSchedule = null;
    if(costDay > 28){
      monthSchedule = await _scheduleLocalRepository.fetchSchedule(dateTime);
    }else{
      monthSchedule = await _scheduleLocalRepository.fetchScheduleByPaycheck(dateTime, costDay);
    }
    return monthSchedule?.timeStamp ?? '';
  }

  Future<void> fetchRemoteSchedule() async {
      thisWeekSchedule =  await _scheduleRemoteRepository.fetchSchedule(
          monthSchedule?.timeStamp! ?? '', _now.year, _now.month, _now.day);
      mergeData();
  }

  void mergeData() {
    if(monthSchedule?.date != null && thisWeekSchedule?.date != null){
      monthSchedule?.date!.addAll(thisWeekSchedule!.date!);
    }else {
      monthSchedule?.date ??= thisWeekSchedule?.date;
    }
  }

  calculateEachCost(){
    log("calculateCost processing");
    totalPay = 0;
    employeesCost = [];

    int monthPay;
    int bonusDayPay;
    int monthIncentivePay;
    int workTime;
    int nightHour = 0;
     // log("${monthSchedule!.toJson()   }");

    for (Date date in monthSchedule!.date!) {
      log("monthSchedule processing");

      nightHour = 0;

      for (Schedule schedule in date.schedule!) {
        monthPay = 0;
        bonusDayPay = 0;
        monthIncentivePay = 0;
        workTime = 0;

        log("Schedule check processing");
        workTime = calculateWorkTime(schedule);
        for (Workers worker in schedule.workers!) {
          log("worker check processing");

          bool isWorkerInList = checkDuplicateWorker(worker, workTime);
          if(monthIncentives!.isNotEmpty){
            monthIncentivePay = calculateMonthIncentivePay(worker);
          }
          log("month processing $workTime ${worker.cost} $monthPay");
          if(!isWorkerInList){
            employeesCost!.add(EmployeeCost(worker.id!,worker.alias!, workTime, 0, worker.cost!,monthPay, bonusDayPay, monthIncentivePay));
          }
        }
      }
    }
    notifyListeners();
  }

  calculateWorkTime(Schedule schedule) {
    int workHour = 0;
    log('workTime processing... schedule time is null? : ${schedule.time != null}');
    for (var workTime in schedule.time!) {

      if(workTime == true){
        workHour++;
      }
    }
    return workHour;
  }

  bool checkDuplicateWorker(Workers worker, int workHour) {
    bool isWorkerInList = false;
    for (EmployeeCost employee in employeesCost!) {
      // log("EmployeeCost processing");

      if(employee.alias == worker.alias) {
        employee.totalWorkTime += workHour;
        isWorkerInList = true;
        break;
      }
    }
    return isWorkerInList;
  }

  int calculateMonthIncentivePay(Workers worker) {
    int monthIncentivePay = 0;
    for (MonthIncentive monthIncentive in monthIncentives!) {
      if(monthIncentive.id == worker.id){
        for (Incentive item in monthIncentive.incentives!) {
          monthIncentivePay += item.cost!;
        }
      }
    }
    return monthIncentivePay;
  }


  calculateTotalCost() {
    if(employeesCost != null) {
      for (EmployeeCost employee in employeesCost!) {
        employee.monthPay = employee.totalWorkTime * employee.hourlyPay;
        totalPay += employee.totalWorkTime * employee.hourlyPay;
      }
    }
  }

  getEmployeeCost(int index){
    return employeesCost![index];
  }

  void setCustomTileExpanded(bool value) {
    customTileExpanded = value;
    notifyListeners();
  }

  void changeMonth(DateTime dateTime) {
    _selectedMonth = dateTime;
    log("changeMonth $dateTime");
    loadData();
    notifyListeners();
  }

  void serPickerYear(param0) {
    _pickerYear = param0;
    _selectedMonth = DateTime(_pickerYear, _selectedMonth.month, 1);
    loadData();
    log("serPickerYear $_selectedMonth");
    notifyListeners();
  }




}
