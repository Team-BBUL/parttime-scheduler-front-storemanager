import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountWithdrawalScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AccountWithdrawalScreen"),
      ),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                  child: Text("회원 탈퇴 유의사항", style : TextStyle(fontSize: 20))
              ),
              Container(
                  child: Text("")
              )
            ],
          )
      )
    );
  }

}