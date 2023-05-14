import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/model/store_management.dart';
import 'package:sidam_storemanager/data/model/user_role.dart';

class StoreManagementViewModel extends ChangeNotifier{

  StoreManagement _storeManagement = StoreManagement(
      location: "location", name: "name", phoneNum: "phoneNum",
      open: "open", close: "close",
      costPolicy: "costPolicy", employee: "employee", payday: "payday"
  );
  List<UserRole> _userRole = [
    UserRole(name: "홍길동", role: "매니저"),
    UserRole(name: "성춘향", role: "직원"),
    UserRole(name: "최판서", role: "아르바이트"),
    UserRole(name: "김길동", role: "신입")
  ];
  List<UserRole> get userRole => _userRole;

  StoreManagement get storeManagement => _storeManagement;
}
