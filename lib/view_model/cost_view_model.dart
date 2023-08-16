import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/schedule_api_respository.dart';
import 'package:sidam_storemanager/view/enum/screen_mode.dart';

import '../data/repository/schedule_local_repository.dart';
import '../model/employee_cost.dart';
import '../model/schedule.dart';

class CostViewModel extends ChangeNotifier{
  final ScheduleLocalRepository _scheduleLocalRepository = ScheduleLocalRepository();
  final ScheduleRemoteRepository _scheduleRemoteRepository;
  late MonthSchedule monthSchedule;
  late MonthSchedule thisWeekSchedule;
  List<EmployeeCost>? employeesCost;
  List<String>? dateList;
  final DateTime _now = DateTime.now();
  String? selectedDate;
  int? dateIndex;
  int costDay = 8;
  late int totalWorkTime = 0;
  late int pay = 0;
  late int totalPay = 0;
  late int prevMonthTotalPay = 0;
  bool isLastDayOfMonth = false;
  bool isCostByMonth = true;
  ScreenMode? state;

  CostViewModel(this._scheduleRemoteRepository){
    loadData();
  }

  Future<void> loadData() async {
    state = ScreenMode.BUSY;
    dateList = await _scheduleLocalRepository.getDateList();
    dateIndex = dateList!.length -1;
    selectedDate = "${_now.year}년 0${_now.month}월";
    if(dateList![dateIndex!] != "${_now.year}년 0${_now.month}월") {
      dateList!.add("${_now.year}년 0${_now.month}월");
    }
    selectedDate = dateList![dateIndex!];
    dateIndex = dateList!.length -1;
    getCost();
    state = ScreenMode.IDLE;
    notifyListeners();
  }

  getCost() async {
    String yearMonth = _scheduleLocalRepository.convertCostScreenDateToYearMonth(selectedDate!);
    await getSchedule(yearMonth);
    prevMonthTotalPay = await _scheduleLocalRepository.getPrevMonthCost(yearMonth, costDay);
    calculateCost();
    calculateTotalCost();
    notifyListeners();
  }

  Future<void> getSchedule(String yearMonth) async {

    if(isLastDayOfMonth){
      monthSchedule = await _scheduleLocalRepository.fetchSchedule(yearMonth);
    }else{
      monthSchedule = await _scheduleLocalRepository.fetchScheduleByPaycheck(yearMonth, costDay);
    }
    if(isDateNowMonth(selectedDate!)) {
      thisWeekSchedule =  await _scheduleRemoteRepository.getData(monthSchedule.timeStamp ?? '0');
      mergeData();
    }
  }

  void mergeData() {
    if(monthSchedule.date != null && thisWeekSchedule.date != null){
      monthSchedule.date!.addAll(thisWeekSchedule.date!);
    }else {
      monthSchedule.date ??= thisWeekSchedule.date;
    }
  }

  calculateCost(){
    totalPay = 0;
    employeesCost = [];
    int dayHour = 0;
    int nightHour = 0;
    for (Date date in monthSchedule.date!) {
      nightHour = 0;
      for (Schedule schedule in date.schedule!) {
        for (var workTime in schedule.time!) {
          if(workTime == true){
            dayHour++;
          }
        }
        for (Workers worker in schedule.workers!) {
          bool isNoWorkerInList = false;
          for (EmployeeCost employee in employeesCost!) {
            if(employee.alias == worker.alias) {
              employee.totalWorkTime += dayHour;
              isNoWorkerInList = true;
              break;
            }
          }
          if(!isNoWorkerInList){
            employeesCost!.add(EmployeeCost(worker.alias!, dayHour, 0, worker.cost!));
          }
        }
        dayHour = 0;
      }
    }
  }

  //TODO calculateTotalCost 코드 중복 => CostViewModel
  void calculateTotalCost() {
    for (EmployeeCost employee in employeesCost!) {
      totalPay += employee.totalWorkTime * employee.hourlyPay;
    }
  }

  getEmployeeCost(int index){
    return employeesCost![index];
  }

  setDate(int selectedItem){
    selectedDate = dateList![selectedItem];
    dateIndex = selectedItem;
    notifyListeners();
  }

  DateTime getPrevDate(){
    if(dateIndex==-1){
      return DateTime(_now.year, _now.month-1);
    }
    int year = int.parse(dateList![dateIndex!].substring(0,4));
    int month = int.parse(dateList![dateIndex!].substring(6,8));
    DateTime prevDate = DateTime(year, month-1);
    return prevDate;
  }

  bool isDateNowMonth(String date) {
    DateTime comparing = DateTime(int.parse(date.substring(0, 4)), int.parse(date.substring(6, 8)));
    return comparing.year == _now.year && comparing.month == _now.month;
  }

}
