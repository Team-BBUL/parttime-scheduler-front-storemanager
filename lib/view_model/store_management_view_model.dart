import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/anniversary_repository.dart';
import 'package:sidam_storemanager/data/repository/incentive_repository.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';
import 'package:sidam_storemanager/model/Incentive.dart';
import 'package:sidam_storemanager/model/anniversary.dart';

import '../model/account_role.dart';
import '../model/store.dart';
import '../utils/sp_helper.dart';

class StoreManagementViewModel extends ChangeNotifier {
  final StoreRepository _storeRepository;
  final UserRepository _userRepository;
  final AnniversaryRepository _anniversaryRepository;
  final IncentiveRepository _incentiveRepository;
  List<int> time = List<int>.generate(24, (index) => index);
  List<int> dayIndexes = List<int>.generate(7, (index) => (index + 1) % 7 + 1);
  List<String> _day =
      List<String>.generate(28, (index) => (index + 1).toString()) + ["말"];
  String? anniversaryName;
  DateTime? date;
  Incentive? _incentive;
  Incentive? _newIncentive;
  List<Incentive>? _incentiveList;
  Map<String, List<Incentive>>? _monthIncentiveList;

  DateTime _updatedAt = DateTime.now();
  List<AccountRole>? _storeUsers;
  List<AccountRole>? _employees;
  List<Anniversary>? _anniversaries;
  MonthIncentive? _monthIncentive;
  Store? _store;
  AccountRole? _selectedEmployee;
  int? _monthIncentiveCost;

  get updatedAt => _updatedAt;
  List<String>? get day => _day;
  Store? get store => _store;
  List<AccountRole>? get employees => _employees;
  AccountRole? get selectedEmployee => _selectedEmployee;
  List<Anniversary>? get anniversaries => _anniversaries;
  MonthIncentive? get monthIncentive => _monthIncentive;
  int? get monthIncentiveCost => _monthIncentiveCost;
  Incentive? get incentive => _incentive;
  Incentive? get newIncentive => _newIncentive;
  List<Incentive>? get incentiveList => _incentiveList;
  Map<String, List<Incentive>>? get monthIncentiveList => _monthIncentiveList;

  StoreManagementViewModel(
      this._storeRepository, this._userRepository, this._anniversaryRepository, this._incentiveRepository){
    _renderStoreName();

  }


  Future<void> sendStoreManagementScreenData() async {
    try{
      await _storeRepository.updateStore(_store!);
      _updatedAt = DateTime.now();
      notifyListeners();
    }catch(e){
      print(e);
      throw e;
    }
  }

  getStoreManagementScreenData() async {
    try {
      await _getStore();
      await _getEmployees();
    }catch(e){
      rethrow;
    }
  }

  Future<void> _getStore() async {
    int? storeId;
    try {
      _store = await _storeRepository.fetchStore(storeId);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> _getEmployees() async {
    try {
      _storeUsers = await _userRepository.fetchAccountRoles();
      _employees =
          _storeUsers?.where((element) => element.role == 'EMPLOYEE').toList();
      log("loadUsers");
      notifyListeners();
    } catch (e) {
      print("error $e");
      throw e;
    }
  }

  Future<void> sendEmployeeScreenData() async {
    try {
      await _userRepository.updateAccountRole(_selectedEmployee!);

      for(int i  = 0; i < _employees!.length; i++){
        if(_employees![i].id == _selectedEmployee!.id){
          _employees![i] = _selectedEmployee!;
        }
      }
      notifyListeners();
    }catch(e){
      print(e);
      throw e;
    }
  }

  Future<void> getEmployee(int id) async {
    try {
      _selectedEmployee = await _userRepository.fetchAccountRole(id);
      notifyListeners();
    } catch (e) {
      print("error $e");
      throw e;
    }
  }

  Future<void> getAnniversary(int employeeId) async {
    try {
      _anniversaries =
          await _anniversaryRepository.fetchAnniversaries(employeeId);
    } catch (e) {
      print(e);
    }
  }
  Future<void> createAnniversary() async {
    try {
      int id = await _anniversaryRepository.postAnniversary(
          Anniversary(name: anniversaryName, date: date),
          _selectedEmployee!.id!);
      await _addAnniversary(id);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> _addAnniversary(int id) async {
    _anniversaries ??= [];
    _anniversaries?.add(Anniversary(id: id, name: anniversaryName, date: date));
    notifyListeners();
  }

  Future<dynamic> removeAnniversary(int id) async{
    try {
      await _anniversaryRepository.deleteAnniversary(id);
      await deleteAnniversary(id);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> deleteAnniversary(int id) async {
    _anniversaries?.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Map<String, bool> costPolicyList = {
    'policyOne': false,
  };

  void setOpenTime(int time) {
    _store?.open = time;
    print('StoreManagerViewModel.setOpenTime:${_store?.open}');
    notifyListeners();
  }

  void setCloseTime(int time) {
    _store?.closed = time;
    print('StoreManagerViewModel.setCloseTime:${_store?.closed}');
    notifyListeners();
  }

  void setPayday(int selectedItem) {
    if(_day[selectedItem] == "말"){
      _store?.payday = 31;

    }else {
      _store?.payday = int.parse(_day[selectedItem]);
    }

    print('StoreManagerViewModel.setPayday:${_store?.payday}');
    notifyListeners();
  }

  void toggle(selected) {
    costPolicyList[selected] = !costPolicyList[selected]!;
    print(costPolicyList[selected]);
    notifyListeners();
  }

  void setStartDayOfWeek(int index) {
    _store?.startDayOfWeek = index;
    notifyListeners();
  }

  void setDeadlineOfSubmit(int index) {
    _store?.deadlineOfSubmit = index;
    print("setDeadLineOfSubmit ${_store?.deadlineOfSubmit}");
    notifyListeners();
  }

  void setAnniversaryName(String text) {
    anniversaryName = text;
    notifyListeners();
  }

  void setAnniversary(int index, DateTime dateTime) {
    _anniversaries?[index].date = dateTime;
    notifyListeners();
  }

  void setDate(DateTime selectedDate) {
    date = selectedDate;
    notifyListeners();
  }

  setStoreName(String text) {
    _store?.name = text;
  }

  setLocation(String text) {
    _store?.location = text;
    log("setLocation ${_store?.location}");
  }

  setIsSalary(bool bool) {
    _selectedEmployee?.salary = bool;
    notifyListeners();
  }

  setCost(String text) {
    _selectedEmployee?.cost = int.parse(text);
    log("setCost ${_selectedEmployee?.cost}");
  }

  setAlias(String text) {
    _selectedEmployee?.alias = text;
  }

  void _renderStoreName() {
    SPHelper spHelper = SPHelper();
    _store = Store();
    _store!.name = spHelper.getStoreName();
  }
  void _calculateMonthIncentiveCost() {
    _monthIncentiveCost = 0;
    if(monthIncentive != null) {
      for (var item in _monthIncentive!.incentives!) {
        _monthIncentiveCost = _monthIncentiveCost! + item.cost!;
      }
    }
    notifyListeners();
  }

  getIncentiveList(int employeeId) async {
    _newIncentive = Incentive(id: null, cost: null, description: '', date: null);

    try {
      _incentiveList = await _incentiveRepository.fetchIncentives(employeeId);
      convertList();
    }catch(e){
      log(e.toString());
      throw(e);
    }
  }
  convertList(){
    _monthIncentiveList = {};
    for (var incentive in incentiveList!) {
      // YearMonth yearMonth = YearMonth(incentive.date!.year, incentive.date!.month);
      String yearMonth = incentive.date!.year.toString() + incentive.date!.month.toString();
      if (_monthIncentiveList!.containsKey(yearMonth)) {
        _monthIncentiveList![yearMonth]!.add(incentive);
        print("test");
      } else {
        _monthIncentiveList![yearMonth] = [incentive];
      }
      _monthIncentiveList![yearMonth]!.sort((b, a) => a.date!.compareTo(b.date!));
    }
  }
  getIncentive(int employeeId, int incentiveId) async {
    try {
      _incentive = await _incentiveRepository.fetchIncentive(employeeId, incentiveId);
    }catch(e){
      log(e.toString());
      throw(e);
    }
  }

  Future<void> postIncentive() async {
    try {
      int newIncentiveId = await _incentiveRepository.postIncentive(_newIncentive!, _selectedEmployee!.id!);
      _newIncentive?.id = newIncentiveId;
      _incentiveList?.add(_newIncentive!);
      convertList();
      notifyListeners();
    }catch(e){
      log(e.toString());
      throw(e);
    }
    _newIncentive = Incentive(id: null, cost: null, description: '', date: null);
  }
  Future<void> deleteIncentive(int id, int employeeId) async {
    try {
      await _incentiveRepository.deleteIncentive(id, employeeId);
      // _incentiveList?.removeAt(id);
      _incentiveList?.removeWhere((element) => element.id == id);
      convertList();
      notifyListeners();
    }catch(e){
      log(e.toString());
      throw(e);
    }
  }


  void setIncentiveDate(DateTime selectedDate) {
    _newIncentive?.date = selectedDate;
    if(newIncentive == null) print("nullzz");
    print(_newIncentive?.date);
    notifyListeners();
  }

  setIncentiveCost(String text) {
    _newIncentive?.cost = int.parse(text);
  }

  setDescription(String text) {
    _newIncentive?.description = text;
  }
}


