import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/main.dart';
import 'package:sidam_storemanager/view/signup.dart';
import 'package:sidam_storemanager/view/store_list.dart';
import 'package:sidam_storemanager/view/store_register.dart';

import '../utils/app_future_builder.dart';
import '../utils/sp_helper.dart';
import 'home.dart';
import 'login.dart';
class CheckLoginScreen extends StatefulWidget{

  @override
  _CheckLoginScreenState createState() => _CheckLoginScreenState();
}

class _CheckLoginScreenState extends State<CheckLoginScreen> {
  SPHelper helper = SPHelper();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppFutureBuilder<void>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          return Container();
        },
      ),
    );
  }

  _checkLoginStatus() async {
    await helper.init();
    await Future.delayed(Duration(seconds: 1));
    bool isLoggedIn = helper.getIsLoggedIn();
    int? currentStoreId = helper.getStoreId();
    bool isRegistered = helper.getIsRegistered();
    String jwt = helper.getJWT();
    if(jwt.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
    log('jwt: $jwt');
    log(isLoggedIn ? '로그인됨' : '로그인안됨');
    log(isRegistered ? '등록됨' : '등록안됨');
    log(currentStoreId != null ? '$currentStoreId' : '가게선택안됨');
    if(isLoggedIn && isRegistered && currentStoreId != null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: '',),
        ),
      );
    }else if (isLoggedIn && isRegistered) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context){
            return StoreListScreen();
          },
        ),
      );
    }else if(isLoggedIn){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(),
        ),
      );
    }else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }
}