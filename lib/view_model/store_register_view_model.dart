import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/main.dart';

import '../model/store.dart';
import '../utils/store_validator.dart';



class StoreRegisterViewModel extends ChangeNotifier{
  Store? _store = Store();
  StoreValidator storeValidator = StoreValidator();
  String indicator = '시';
  List<int> time = List<int>.generate(24, (index) => index);
  bool isTextFieldChanged = false;
  Map<String, String> _errorMessages = {};
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _paydayController = TextEditingController();
  final TextEditingController _startDayOfWeekController = TextEditingController();
  final TextEditingController _deadlineOfSubmitController = TextEditingController();

  final List<String> _day =
      List<String>.generate(28, (index) => (index + 1).toString()) + ["말"];
  Map<String, String> get errorMessage => _errorMessages;
  StoreRepository _storeRepository = StoreRepositoryImpl();

  Store? get store => _store;
  get timeController => _timeController;
  get paydayController => _paydayController;
  get day => _day;

  get startDayOfWeekController => _startDayOfWeekController;
  get deadlineOfSubmitController => _deadlineOfSubmitController;



  void setOpenTime(int time){
     _store?.open = time;
     _timeController.text ='${_store?.open ?? 0} 시 ~ ${_store?.closed ?? 0} 시';
     notifyListeners();
  }

  void setClosedTime(int time){
    _store?.closed = time;
    _timeController.text ='${_store?.open ?? 0} 시 ~ ${_store?.closed ?? 0 } 시';
    print('StoreManagerViewModel.setCloseTime:${_store?.closed}');

    notifyListeners();
  }

  void setPayday(int selectedItem) {
    if(_day[selectedItem] == "말"){
      _store?.payday = 31;

    }else {
      _store?.payday = int.parse(_day[selectedItem]);
    }
    _paydayController.text = '${_store?.payday == 31 ?'말' : _store?.payday} 일';
    print('StoreManagerViewModel.setPayday:${_store?.payday}');
    notifyListeners();
  }

  void setStartDayOfWeek(int index) {
    _store?.startDayOfWeek = index;
    _startDayOfWeekController.text = '매주 ${ _store?.convertWeekdayToKorean(_store?.startDayOfWeek)}요일';
    notifyListeners();
  }

  void setDeadlineOfSubmit(int index) {
    _store?.deadlineOfSubmit = index;
    _deadlineOfSubmitController.text = '매주 ${ _store?.convertWeekdayToKorean(_store?.deadlineOfSubmit)}요일';
    notifyListeners();
  }
  // getStore (context) async {
  //   _store  = await _storeRepository.fetchStore(null);
  //   Navigator.pushAndRemoveUntil(
  //       context, MaterialPageRoute(
  //       builder:
  //           (context) => const MyHomePage(title: 'title')
  //   ),
  //           (route) => false
  //   );
  //   return _store;
  // }

  void setStoreInfo({String? name, String? location, String? phone,}){
    _store?.name = name;
    _store?.location = location;
    _store?.phone = phone;
    _store?.payday ??= -1;
    _store?.costPolicy = 1;
    _store?.startDayOfWeek ?? 0;
    _store?.open ?? 0;
    _store?.closed ?? 0;
    _store?.deadlineOfSubmit ?? 1;
    isTextFieldChanged = false;
  }

  sendStoreInfo(context) async{
    try {
      print('StoreRegisterViewModel.sendStoreInfo:${_store?.toJson()}');
      _errorMessages = {};
      final statusCode = await _storeRepository.createStore(_store!);

      if(statusCode == 200){
        Navigator.pushAndRemoveUntil(
            context,MaterialPageRoute(builder:
            (context)=>MyHomePage(title: 'title')),
                (route) => false);
      }
    }catch (e){
      log("try catch : ${e.toString()}");
      log("_errorMessages : $_errorMessages");
    }
    notifyListeners();
  }

  void setTextFieldChanged(){
    isTextFieldChanged = true;
    // notifyListeners();
  }


}
