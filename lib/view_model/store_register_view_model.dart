import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/data/repository/store_repository_mock.dart';
import 'package:sidam_storemanager/main.dart';

import '../model/store.dart';



class StoreRegisterViewModel extends ChangeNotifier{
  Store? _store = Store();
  String indicator = '시';
  bool isTextFieldChanged = false;
  Map<String, String> _errorMessages = {};
  TextEditingController _timeController = TextEditingController();
  Map<String, String> get errorMessage => _errorMessages;
  Store? get store => _store;
  StoreRepository _storeRepository = StoreRepositoryImpl();

  List<int> time = List<int>.generate(24, (index) => index);

  get timeController => _timeController;

  void setOpenTime(int time){
     _store?.open = time;
     _timeController.text ='${_store?.open ?? 0} 시 ~ ${_store?.close ?? 0} 시';
     notifyListeners();
  }

  void setCloseTime(int time){
    _store?.close = time;
    _timeController.text ='${_store?.open ?? 0} 시 ~ ${_store?.close ?? 0 } 시';
    print('StoreManagerViewModel.setCloseTime:${_store?.close}');

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

  void setStoreInfo(String newName, String newLocation, String newPhone,
      int newPayday, int newWeekStartDay){
    _store?.name = newName;
    _store?.location = newLocation;
    _store?.phone = newPhone;
    _store?.payday = newPayday;
    _store?.costPolicy = 1;
    _store?.weekStartDay = newWeekStartDay;
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
