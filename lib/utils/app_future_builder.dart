import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sidam_storemanager/utils/dialog_message.dart';

import '../model/jwt_exception.dart';
import '../view/login.dart';

class AppFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) builder;

  AppFutureBuilder({required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          if(snapshot.error.runtimeType == JWTException){
            log("Future builder ${snapshot.error}");
            processTokenError(context);
          }
           Message().showAlertDialog(
              context: context,
              title: "에러",
              message: "에러가 발생했습니다.");
           return Container();
        } else {
          return builder(context, snapshot);
        }
      },
    );
  }

  void processTokenError(context) async{
    await Message().showAlertDialog(
        context: context,
        title: "에러",
        message: "로그인을 다시해주세요.");
    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context) => LoginScreen())
    );
  }
}