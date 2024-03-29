import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/anniversary_repository.dart';
import 'package:sidam_storemanager/data/repository/incentive_repository.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';
import 'package:sidam_storemanager/model/Incentive.dart';
import 'package:sidam_storemanager/model/anniversary.dart';

import '../data/repository/cost_policy_repository.dart';
import '../model/account.dart';
import '../model/account_role.dart';
import '../model/cost_policy.dart';
import '../model/store.dart';
import '../utils/sp_helper.dart';

class StoreManagementViewModel extends ChangeNotifier {

  final StoreRepository _storeRepository;
  final UserRepositoryImpl _userRepository;
  final AnniversaryRepository _anniversaryRepository;
  final IncentiveRepository _incentiveRepository;
  final CostPolicyRepository _costPolicyRepository;
  List<int> time = List<int>.generate(24, (index) => index);
  List<String> _day =
      List<String>.generate(28, (index) => (index + 1).toString()) + ["말"];
  List<double> _multiplies =
  List<double>.generate(20, (index) =>   double.parse(((index + 11) * 0.1).toStringAsFixed(1)));
  List<int> _levels = List<int>.generate(6, (index) => index);
  List<int> _costPolicyDays = List<int>.generate(31, (index) => index + 1);
  String? anniversaryName;
  DateTime? date;
  double? multiplyValue;
  Incentive? _incentive;
  Incentive? _newIncentive;
  List<Incentive>? _incentiveList;
  Map<String, List<Incentive>>? _monthIncentiveList;

  DateTime _updatedAt = DateTime.now();
  List<AccountRole>? _storeUsers;
  List<AccountRole>? _employees;
  List<Anniversary>? _anniversaries;
  List<CostPolicy>? _policyList;
  MonthIncentive? _monthIncentive;
  Store? _store;
  AccountRole? _selectedEmployee;
  AccountRole? _newEmployee;
  int? _monthIncentiveCost;
  CostPolicy? _newCostPolicy;

  String? _idStatusCode;

  bool _clearLoading = false;
  bool _clearSuccess = false;

  get idStatusCode => _idStatusCode;
  get updatedAt => _updatedAt;
  List<String>? get day => _day;
  List<double>? get multiplies => _multiplies;
  List<int>? get levels => _levels;
  List<int>? get costPolicyDays => _costPolicyDays;
  Store? get store => _store;
  List<AccountRole>? get employees => _employees;
  AccountRole? get selectedEmployee => _selectedEmployee;
  AccountRole? get newEmployee => _newEmployee;
  List<Anniversary>? get anniversaries => _anniversaries;
  MonthIncentive? get monthIncentive => _monthIncentive;
  CostPolicy? get newCostPolicy => _newCostPolicy;
  int? get monthIncentiveCost => _monthIncentiveCost;
  Incentive? get incentive => _incentive;
  Incentive? get newIncentive => _newIncentive;
  List<Incentive>? get incentiveList => _incentiveList;
  List<CostPolicy>? get policyList => _policyList;
  Map<String, List<Incentive>>? get monthIncentiveList => _monthIncentiveList;
  get clearLoading => _clearLoading;
  get clearSuccess => _clearSuccess;

  StoreManagementViewModel(
      this._storeRepository, this._userRepository, this._anniversaryRepository,
      this._incentiveRepository, this._costPolicyRepository){
    _newEmployee ??= AccountRole.newEmployee(salary: false, alias: '');
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
      await _getPolicies();
    }catch(e){
      rethrow;
    }
  }
  void initEmployeeRegisterScreen() {
    _idStatusCode = null;
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

  Future<void> _getPolicies() async {
    _newCostPolicy = CostPolicy(multiplyCost: 2.0);
    try{
      _policyList = await _costPolicyRepository.fetchAllPolicy();
    }catch(e){
      log("_getPolicies error : $e");
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
      await _deleteAnniversary(id);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> _deleteAnniversary(int id) async {
    _anniversaries?.removeWhere((element) => element.id == id);
    notifyListeners();
  }
  Future<void> createPolicy() async {
    try {
      int id = await _costPolicyRepository.postPolicy(CostPolicy( multiplyCost: _newCostPolicy!.multiplyCost,
          description: _newCostPolicy!.description, day: _newCostPolicy!.day));
      await _addPolicy(id);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> _addPolicy(int id) async {
    _policyList?.add(CostPolicy(id: id, multiplyCost: _newCostPolicy!.multiplyCost,
        description: _newCostPolicy!.description, day: _newCostPolicy!.day));
    notifyListeners();
  }

  Future<dynamic> removePolicy(int id) async{
    try {
      await _costPolicyRepository.deletePolicy(id);
      await _deletePolicy(id);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> _deletePolicy(int id) async {
    _policyList?.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void setOpenTime(int time) {
    _store?.open = time;
    log('StoreManagerViewModel.setOpenTime:${_store?.open}');
    notifyListeners();
  }

  void setCloseTime(int time) {
    _store?.closed = time;
    log('StoreManagerViewModel.setCloseTime:${_store?.closed}');
    notifyListeners();
  }

  void setPayday(int selectedItem) {
    if(_day[selectedItem] == "말"){
      _store?.payday = 31;

    }else {
      _store?.payday = int.parse(_day[selectedItem]);
    }

    log('StoreManagerViewModel.setPayday:${_store?.payday}');
    notifyListeners();
  }

  void setStartDayOfWeek(int index) {
    _store?.startDayOfWeek = index;
    notifyListeners();
  }

  void setDeadlineOfSubmit(int index) {
    _store?.deadlineOfSubmit = index;
    log("setDeadLineOfSubmit ${_store?.deadlineOfSubmit}");
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

  void setMultiplyValue(int i) {
    _newCostPolicy!.multiplyCost = _multiplies[i];
    print(i);
    print(_newCostPolicy!.multiplyCost);
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

  void setLevel(int selectedItem) {
    _selectedEmployee?.level = selectedItem;
    log('StoreManagerViewModel.setLevel:${_selectedEmployee?.level}');
    notifyListeners();
  }

  setNewIsSalary(bool bool) {
    _newEmployee?.salary = bool;
    notifyListeners();
  }

  setNewCost(String text) {
    _newEmployee?.cost = int.parse(text);
    log("setCost ${_newEmployee?.cost}");
  }

  setNewAlias(String text) {
    _newEmployee?.alias = text;
  }

  void setNewLevel(int selectedItem) {
    _newEmployee?.level = selectedItem;
    log('StoreManagerViewModel.setLevel:${_newEmployee?.level}');
    notifyListeners();
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
    notifyListeners();
  }

  setIncentiveCost(String text) {
    _newIncentive?.cost = int.parse(text);
  }

  setDescription(String text) {
    _newIncentive?.description = text;
  }

  setPolicyDescription(String text) {
    _newCostPolicy?.description = text;
  }

  void setCostPolicyDate(int selected) {
    _newCostPolicy?.day = costPolicyDays![selected];
    notifyListeners();
  }

  Future<void> checkAccountId(String? accountId) async{
    if(accountId != null) {
      _idStatusCode = await _userRepository.checkId(accountId);
    }
    notifyListeners();
  }

  createNewEmployee(String accountId, String pw, String name) async {
    _newEmployee?.account = Account();
    _newEmployee?.account?.originAccountId = accountId;
    _newEmployee?.account?.originPassword = pw;
    _newEmployee?.alias = name;
    log("createNewEmployee ${accountId} ");
    log("createNewEmployee ${pw} ");
    log("createNewEmployee newEmployee account accountId ${_newEmployee?.account?.originAccountId} ");
    log("createNewEmployee newEmployee account pw ${_newEmployee?.account?.originPassword} ");
    log("createNewEmployee alias ${_newEmployee?.alias} ");

    try{
      await _userRepository.createEmployee(_newEmployee!);
      await _getEmployees();
    }catch(e){
      log(e.toString());
      throw(e);
    }
  }

  // 근무자 ID, PW 초기화
  Future<void> clearEmployeeAuth() async {
    if (!_clearLoading){
      _clearLoading = true;

      if (_selectedEmployee == null) {
        return;
      }

      int employeeId = _selectedEmployee?.id ?? 0;

      if (employeeId == 0) {
        return;
      }

      try {
        await _userRepository.clearEmployee(employeeId);
        _clearSuccess = true;
        Future.delayed(const Duration(milliseconds: 500), (){
          _clearLoading = false;
          notifyListeners();
        });
      } catch (e) {
        log('$e');
        _clearSuccess = false;
      }
    }
  }
}


