import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/anniversary_repository.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';
import 'package:sidam_storemanager/model/anniversary.dart';

import '../model/account_role.dart';
import '../model/store.dart';

class StoreManagementViewModel extends ChangeNotifier{
  StoreRepository _storeRepository;
  UserRepository _userRepository;
  AnniversaryRepository _anniversaryRepository;
  List<int> time = List<int>.generate(24, (index) => index);
  List<int> dayIndexes = List<int>.generate(7, (index) => (index + 1) % 7 + 1);
  String? anniversaryName;
  DateTime? date;
  Store? _store;
  List<AccountRole>? _storeUsers;
  List<AccountRole>? _employees;
  List<Anniversary>? _anniversaries;
  List<Anniversary>? _newAnniversaries;

  AccountRole? _selectedEmployee;

  Store? get store => _store;
  List<AccountRole>? get employees => _employees;
  AccountRole? get selectedEmployee => _selectedEmployee;
  List<Anniversary>? get anniversaries => _anniversaries;
  List<Anniversary>? get newAnniversaries => _newAnniversaries;

  StoreManagementViewModel(this._storeRepository,this._userRepository,this._anniversaryRepository){
    getEmployees();
    getStore();
  }

  Future<void> getEmployees() async {
    try {
      _storeUsers = await _userRepository.fetchUsers();
      _employees = _storeUsers?.where((element) => element.role == 'EMPLOYEE').toList();
      log("loadUsers");
      notifyListeners();
    } catch (e) {
      print("error $e");
      throw e;
    }
  }

  Future<void> getStore() async {
    _store = null;
    int? storeId;
    try {
      _store = await _storeRepository.fetchStore(storeId);
      print("store management view model");
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }


  Future<void> getAnniversary(int employeeId) async{
    try{
      _anniversaries = await _anniversaryRepository.fetchAnniversaries(employeeId);
    }catch(e){
      print(e);
    }
  }

  Map<String, bool> costPolicyList = {
    'policyOne': false,
  };

  void setOpenTime(int time){
    _store?.open = time;
    print('StoreManagerViewModel.setOpenTime:${_store?.open}');
    notifyListeners();
  }

  void setCloseTime(int time){
    _store?.close = time;
    print('StoreManagerViewModel.setCloseTime:${_store?.close}');
    notifyListeners();
  }

  void toggle(selected){
    costPolicyList[selected] = !costPolicyList[selected]!;
    print(costPolicyList[selected]);
    notifyListeners();
  }

  convertWeekdayToKorean(weekday) {
    // int? weekday = this.?.weekday;
    if(weekday == 1) {
      return '월';
    }else if(weekday == 2) {
      return '화';
    }else if(weekday == 3) {
      return '수';
    }else if(weekday == 4) {
      return '목';
    }else if(weekday == 5) {
      return '금';
    }else if(weekday == 6) {
      return '토';
    }else if(weekday == 7) {
      return '일';
    }
  }

  void setWeekStartDay(int index) {
    _store?.weekStartDay = index;
    notifyListeners();
  }

  void setUnworkableWeekdayDeadline(int index) {
    _store?.unworkableDaySelectDeadline = index;
    notifyListeners();
  }

  void setStartWeekday(int index) {
    _store?.unworkableDaySelectDeadline = index;
    notifyListeners();
  }

  void setEmployee(AccountRole employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  Future<dynamic> addAnniversary() async {
    _newAnniversaries ??= [];
    _newAnniversaries?.add(Anniversary(name: anniversaryName, date: date));
    notifyListeners();
  }
  void setAnniversaryName(String text){
    anniversaryName = text;
    notifyListeners();
  }
  void setAnniversary(int index, DateTime dateTime) {
    _newAnniversaries?[index].date = dateTime;
    notifyListeners();
  }

  void setDate(DateTime selectedDate) {
    date = selectedDate;
    notifyListeners();
  }


}
