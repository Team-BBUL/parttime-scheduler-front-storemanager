import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sidam_storemanager/data/local_data_source.dart';

import '../../model/schedule.dart';


class ScheduleLocalRepository{

  String? _yearMonth;
  String? _prevYearMonth;
  int? _costDay;
  String? _recentTimeStamp;

  Future<MonthSchedule> fetchSchedule(String yearMonth) async {
    try {
      dynamic decodedData = await loadJson(yearMonth);
      return MonthSchedule.fromJson(decodedData);
    } catch (e) {
      print('fetchSchedule : Error loading cells from JSON: $e');
    }
    return MonthSchedule();
  }

  Future<MonthSchedule> fetchScheduleByPaycheck(String date, int costDay) async {
    initData(date, costDay);
    Map<String,dynamic> data = await getScheduleBasedOnCostDay();
    print("fetchScheduleByPaycheck = $data");
    return MonthSchedule.fromJson(data);
  }

  Future<int> getPrevMonthCost(String date, int costDay) async{
    String prevYearMonth = getPrevYearMonth(date, costDay);
    initData(prevYearMonth, costDay);
    Map<String,dynamic> data = await getScheduleBasedOnCostDay();
    return calculateTotalCostWithJson(data);
  }
  //TODO calculateTotalCost 코드 중복 => ScheduleRepository
  int calculateTotalCostWithJson(Map<String, dynamic> data) {
    int totalCost = 0;

    List<dynamic> dates = data['date'];
    for (var date in dates) {
      List<dynamic> schedules = date['schedule'];
      for (var schedule in schedules) {
        List<dynamic> time = schedule['time'];
        int times = 0;
        for (var i = 0; i < time.length; i++) {
          if (time[i] == true) {
            times++;
          }
        }
        List<dynamic> workers = schedule['workers'];
        for (var i = 0; i < workers.length; i++) {
          int cost = workers[i]['cost'];
          totalCost += cost * times;
        }
      }
    }

    return totalCost;
  }

  initData(String date, int day){
    _yearMonth = date;
    _costDay = day;
    _prevYearMonth = getPrevYearMonth(date, day);
  }

  String getPrevYearMonth(String yearMonth, int costDay) {
    DateTime curDate = DateTime(int.parse(yearMonth.substring(0,4)),
        int.parse(yearMonth.substring(4,6)), costDay);
    DateTime prevDate = DateTime(curDate.year, curDate.month-1, costDay+1);
    if( 9 < curDate.month - 1 ) {
      return '${prevDate.year}${prevDate.month}';
    } else {
      return '${prevDate.year}${prevDate.month.toString().padLeft(2, '0')}';
    }
  }

  Future<Map<String, dynamic>> getScheduleBasedOnCostDay() async {
    List<dynamic> prevMonthData = [];
    List<dynamic> curMonthData = [];

    prevMonthData = await getMonthData(_prevYearMonth);
    curMonthData = await getMonthData(_yearMonth);

    if(prevMonthData.isNotEmpty && curMonthData.isNotEmpty) {
      prevMonthData.addAll(curMonthData);
    } else if( prevMonthData.isNotEmpty) {
      prevMonthData = prevMonthData;
    } else if( curMonthData.isNotEmpty) {
      prevMonthData = curMonthData;
    }
    return {'date' : prevMonthData, 'time_stamp' : _recentTimeStamp};
  }

  Future<List<dynamic>> getMonthData(String? date) async{
    dynamic decodedData = await loadJson(date!);
    if(decodedData.isNotEmpty) {
      setRecentTimeStamp(decodedData);
      decodedData = filterData(decodedData, date);
    }
    return decodedData;
  }

  void setRecentTimeStamp(decodedData) {
    if(_recentTimeStamp == null) {
      _recentTimeStamp = decodedData['time_stamp'];
    } else {
      if(convertTimeStampToDateTime(_recentTimeStamp).isBefore
        (convertTimeStampToDateTime(decodedData['time_stamp']))){
        _recentTimeStamp = decodedData['time_stamp'];
      }
    }
  }

  Future<dynamic> loadJson(String date) async {
    LocalDataSource localDataSource = LocalDataSource();
    List<dynamic> data = [];
    try {
      localDataSource.loadJson(date);
    } catch (e) {
      log('loadJson : Error loading cells from JSON: $e');
    }
    return data;
  }

  DateTime convertTimeStampToDateTime(String? timeStamp){
    String year = timeStamp!.substring(0,4);
    String month = timeStamp.substring(5,7);
    String day = timeStamp.substring(8,10);
    String hour = timeStamp.substring(11,13);
    String minute = timeStamp.substring(14,16);
    String second = timeStamp.substring(17,19);
    DateTime recentTimeStamp = DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(hour),
        int.parse(minute),
        int.parse(second));
    return recentTimeStamp;
  }

  List filterData(decodedData, String date) {

    List<Map<String, dynamic>> filteredData = deleteDateBodyAndNull(decodedData);

    if(int.parse(date) < int.parse(_yearMonth!)){
      filteredData = removeUnderCostDay(filteredData);
    }else{
      filteredData = removeOverCostDay(filteredData);
    }
    return filteredData;
  }

  List<Map<String, dynamic>> deleteDateBodyAndNull(decodedData) {
    return (decodedData['date'] as List<dynamic>?)
        ?.where((item) => item != null)
        .cast<Map<String, dynamic>>()
        .toList() ?? [];
  }

  List<Map<String, dynamic>> removeUnderCostDay(List<Map<String, dynamic>> dateList) {
    return dateList.where((item) => int.parse(item['day'].substring(8,10)) > _costDay!).toList();
  }

  List<Map<String, dynamic>> removeOverCostDay(List<Map<String, dynamic>> dateList) {
    return dateList.where((item) => int.parse(item['day'].substring(8,10)) <= _costDay!).toList();
  }

  Future<List<String>> getDateList() async {
    List<String> fileNames = await getFileNames();
    List<String> dateList = fileToDate(fileNames);
    return dateList;
  }

   getFileNames() async{
    LocalDataSource localDataSource = LocalDataSource();
    try {
      return await localDataSource.getScheduleFileNames();
    } catch (e) {
      log('getFileNames : Error get schedule file name: $e');
    }
  }

  List<String> fileToDate(List<String> fileList) {
    List<String> dateList = [];
    for (String yearMonth in fileList) {
      int year = int.parse(yearMonth.substring(0, 4));
      int month = int.parse(yearMonth.substring(4, 6));
      String parsedString = '$year년 ${month.toString().padLeft(2, '0')}월';
      dateList.add(parsedString);
    }
    return dateList;
  }

  // Future<List<String>> getFileNames() async {
  //   String directory = 'asset/json/';
  //
  //   List<String> assetList = await rootBundle.loadString('AssetManifest.json')
  //       .then((jsonStr) => json.decode(jsonStr) as Map<String, dynamic>)
  //       .then((map) => map.keys.toList());
  //
  //   List<String> jsonFiles = assetList
  //       .where((file) => file.startsWith(directory) && file.endsWith('.json'))
  //       .toList();
  //
  //   return jsonFiles;
  // }

  String convertCostScreenDateToYearMonth(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(6, 8);
    return year + month;
  }

  String convertTimeStampToYearMonth(String date){
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    return year + month;
  }

  void saveSchedule(Map<String, dynamic> decodedData, String timeStamp) async {
    LocalDataSource localDataSource = LocalDataSource();

    String yearMonth = convertTimeStampToYearMonth(timeStamp);
    localDataSource.saveModels(decodedData, yearMonth);
    log("schedule saved");
  }

}