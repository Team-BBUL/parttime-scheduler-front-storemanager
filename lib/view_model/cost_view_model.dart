import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/schedule_api_respository.dart';

import '../data/repository/schedule_local_repository.dart';
import '../model/employee_cost.dart';
import '../model/schedule.dart';

class CostViewModel extends ChangeNotifier{
  final ScheduleLocalRepository _scheduleLocalRepository = ScheduleLocalRepository();
  final ScheduleRemoteRepository _scheduleRemoteRepository;
  MonthSchedule? monthSchedule;
  MonthSchedule? thisWeekSchedule;
  List<EmployeeCost>? employeesCost;
  List<String>? dateList;
  final DateTime _now = DateTime.now();
  String? selectedDate;
  int? dateIndex;
  int costDay = 8;
  int totalWorkTime = 0;
  int pay = 0;
  int totalPay = 0;
  int prevMonthTotalPay = 0;
  bool isLastDayOfMonth = false;
  bool isCostByMonth = true;

  CostViewModel(this._scheduleRemoteRepository);

  Future<void> loadData() async {
    try {
      dateList = await _scheduleLocalRepository.getDateList();
      sortDateIndex();
    } catch (e) {
      print('CostViewModel loadData : $e');
    }

    String yearMonth;
    if(selectedDate != null) {
      yearMonth = _scheduleLocalRepository.convertCostScreenDateToYearMonth(
          selectedDate!);
      await getLocalSchedule(yearMonth);
      await getRemoteSchedule(selectedDate);
      if(dateList!.length > 1){
        prevMonthTotalPay = await _scheduleLocalRepository.getPrevMonthCost(yearMonth, costDay);
      }
    }else{
      await getRemoteSchedule("${_now.year}년 ${appendMonthZero(_now.month)}월");
    }
    await getCost();
    notifyListeners();
  }

  void sortDateIndex() {
    dateIndex = dateList!.length - 1;
    selectedDate = "${_now.year}년 0${_now.month}월";
    if (dateList![dateIndex!] != "${_now.year}년 0${_now.month}월") {
      dateList!.add("${_now.year}년 0${_now.month}월");
    }
    selectedDate = dateList![dateIndex!];
    dateIndex = dateList!.length - 1;
  }

  getCost() async {
    calculateCost();
    calculateTotalCost();
  }

  Future<void> getLocalSchedule(String yearMonth) async {
    if(isLastDayOfMonth){
      monthSchedule = await _scheduleLocalRepository.fetchSchedule(yearMonth);
    }else{
      monthSchedule = await _scheduleLocalRepository.fetchScheduleByPaycheck(yearMonth, costDay);
    }
  }

  Future<void> getRemoteSchedule(date) async {
    print("test");
      final monthSchedule = this.monthSchedule;
      if(monthSchedule != null){
        print("test1");
        thisWeekSchedule =  await _scheduleRemoteRepository.fetchSchedule(
            monthSchedule.timeStamp!, _now.year, _now.month, _now.day);

      }else{
        print("test2");

        thisWeekSchedule =  await _scheduleRemoteRepository.fetchSchedule(
            '${_now.year}-${appendMonthZero(_now.month)}', _now.year, _now.month, _now.day);
      }
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
    totalPay = 0;
    employeesCost = [];
    int dayHour = 0;
    int nightHour = 0;
    if(monthSchedule == null){
      return;
    }
    for (Date date in monthSchedule!.date!) {
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
    if(employeesCost != null) {
      for (EmployeeCost employee in employeesCost!) {
        totalPay += employee.totalWorkTime * employee.hourlyPay;
      }
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

  appendMonthZero(int month){
    if(month < 10){
      return "0${month}";
    }
    return month;
  }
}
