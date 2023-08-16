import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_cupertino_picker.dart';

class Message{
  void showConfirmDialog({required BuildContext context,
    required String title, required String message, required Future Function() apiCall, required int popCount}) async{
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("취소")
              ),
              TextButton(
                  onPressed: (){
                    apiCall.call().then((_){
                      for(int i = 0; i < popCount; i++){
                        Navigator.pop(context);
                      }
                    }).catchError((e){
                      showAlertDialog(context: context, title: "실패했습니다", message: "message");
                      Navigator.pop(context);
                      print(e);
                    });
                  },
                  child: Text("확인")
              )
            ],
          );
        }
    );
  }

  void showAlertDialog({required BuildContext context,
    required String title, required String message,}) async{
    await Future.delayed(Duration(microseconds: 1));
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("학인")
              ),
            ],
          );
        }
    );
    Navigator.pop(context);
  }



}