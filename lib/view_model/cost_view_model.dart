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
  int costDay = 8;
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
    // String yearMonth = DateFormat('yyyyMM').format(_selectedMonth);
    employeesCost = [];
    monthSchedule = null;
    try {
      log("----------------------------------------loadData-----------------------");
      // await loadDateList();
      // await fetchRemoteSchedule();
      await fetchLocalSchedule(_selectedMonth);

      // await loadDateList();
      await getCost();
      await getMonthIncentive();
    }catch(e){
      log("loadData $e");
    }
    notifyListeners();
  }

  // loadDateList() async{
  //   dateList = await _scheduleLocalRepository.getDateList();
  //   if(dateList!.isNotEmpty) {
  //     dateIndex = dateList!.length - 1;
  //   }
  //   log("loadDateList $dateList");
  //   notifyListeners();
  // }

  loadSchedule() async{
    log("----------------------------------------loadSchedule-----------------------");

    // if(dateIndex == dateList!.length){
    //   await fetchRemoteSchedule();
    // }else{
    //   await fetchLocalSchedule(dateList![dateIndex!]);
    // }
  }

  getCost() async {
    await calculateCost();
    await calculateTotalCost();
    prevMonthTotalPay = await _scheduleLocalRepository.getPrevMonthCost(
        selectedMonth, costDay);
    notifyListeners();
  }

  getMonthIncentive() async{
    monthIncentives = await _incentiveRepository.fetchMonthIncentives(selectedMonth);
    log("getMonthIncentive success");
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
    log("message");
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

  calculateCost(){
    log("calculateCost processing");
    totalPay = 0;
    employeesCost = [];

    int monthPay = 0;
    int bonusDayPay = 0;
    int monthIncentivePay = 0;
    int dayHour = 0;
    int nightHour = 0;
     // log("${monthSchedule!.toJson()   }");
    if(monthSchedule?.timeStamp == null){

      return;
    }
    for (Date date in monthSchedule!.date!) {
      log("monthSchedule processing");

      nightHour = 0;
      for (Schedule schedule in date.schedule!) {
        log("Schedule processing");

        for (var workTime in schedule.time!) {
          log("workTime processing");

          if(workTime == true){
            dayHour++;
          }
        }
        for (Workers worker in schedule.workers!) {
          log("worker processing");

          bool isNoWorkerInList = false;

          for (EmployeeCost employee in employeesCost!) {
            // log("EmployeeCost processing");

            if(employee.alias == worker.alias) {
              employee.totalWorkTime += dayHour;
              isNoWorkerInList = true;
              break;
            }
          }
          for (MonthIncentive monthIncentive in monthIncentives!) {
            if(monthIncentive.id == worker.id){
              for (Incentive item in monthIncentive.incentives!) {
                monthIncentivePay += item.cost!;
              }
            }
          }
          log("EmployeeCost processing");
          monthPay = (dayHour * worker.cost!) + bonusDayPay + monthIncentivePay;
          if(!isNoWorkerInList){
            employeesCost!.add(EmployeeCost(worker.id!,worker.alias!, dayHour, 0, worker.cost!,monthPay, bonusDayPay, monthIncentivePay));
          }
        }
        monthPay = 0;
        bonusDayPay = 0;
        monthIncentivePay = 0;
        dayHour = 0;
      }
    }
  }

  //TODO calculateTotalCost 코드 중복 => CostViewModel
  calculateTotalCost() {
    if(employeesCost != null) {
      for (EmployeeCost employee in employeesCost!) {
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
