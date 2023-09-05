import 'dart:developer';

import 'package:flutter/material.dart';
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
  MonthIncentive? monthIncentive;

  List<EmployeeCost>? employeesCost;
  List<DateTime>? dateList;
  String? selectedDate;
  int? dateIndex;
  int costDay = 8;
  int totalWorkTime = 0;
  int pay = 0;
  int totalPay = 0;
  int prevMonthTotalPay = 0;

  CostViewModel(this._scheduleRemoteRepository, this._incentiveRepository){
    loadData();
  }

  Future<void> loadData() async {
    employeesCost = [];
    monthSchedule = null;
    try {
      log("----------------------------------------loadData-----------------------");
      await loadDateList();
      await fetchLocalSchedule(dateList![dateList!.length - 1]);
      await fetchRemoteSchedule();
      await loadDateList();
      await getMonthIncentive();

      await getCost();
      dateIndex = dateList!.length -1;
    }catch(e){
      log("loadData $e");
    }
    notifyListeners();
  }

  loadDateList() async{
    dateList = await _scheduleLocalRepository.getDateList();
    dateIndex = dateList!.length -1;
    log("loadDateList $dateList");
    notifyListeners();
  }

  loadSchedule() async{
    log("----------------------------------------loadSchedule-----------------------");

    if(dateIndex == dateList!.length){
      await fetchRemoteSchedule();
    }else{
      await fetchLocalSchedule(dateList![dateIndex!]);
    }
  }

  getCost() async {
    await calculateCost();
    await calculateTotalCost();
    if (dateList!.length > 1) {
      prevMonthTotalPay = await _scheduleLocalRepository.getPrevMonthCost(
          dateList![dateIndex!], costDay);
    }
    notifyListeners();
  }

  getMonthIncentive() async{
    monthIncentive = await _incentiveRepository.fetchMonthIncentives(dateList![dateIndex!]);
    log("$monthIncentive");
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

  calculateCost(){
    totalPay = 0;
    employeesCost = [];
    int dayHour = 0;
    int nightHour = 0;
    if(monthSchedule?.timeStamp == null){

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

  setDate(int selectedItem){
    dateIndex = selectedItem;
    notifyListeners();
  }
}
