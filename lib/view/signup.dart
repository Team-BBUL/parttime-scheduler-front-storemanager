import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';
import 'package:sidam_storemanager/view/login.dart';
import 'package:sidam_storemanager/view/store_register_page.dart';

import '../main.dart';
import '../model/account.dart';
import '../utils/app_color.dart';
import '../utils/app_toast.dart';
import 'check_login.dart';

class SignupScreen extends StatefulWidget{

  @override
  _SignupState createState() => _SignupState();

}

class _SignupState extends State<SignupScreen>{
  final UserRepository _userRepository = UserRepositoryImpl();
  TextEditingController _aliasController = TextEditingController();
  Future<Account>? _accountFuture;
  Account? _account;

  @override
  void initState() {
    super.initState();
    try{
      _accountFuture =  _userRepository.fetchUser();

    }catch(e){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder:
              (context) =>
              CheckLoginScreen(),
          ),
              (route) => false
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('TextField'),
        ),
        body: FutureBuilder<Account>(
          future: _accountFuture,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }else{
              _account = snapshot.data;

              return SingleChildScrollView (
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: const Text('확인되는 회원이 없습니다. 가입하시겠어요?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                        child: TextFormField(
                          initialValue: _account?.name,
                          onChanged: (text) {
                            _account?.name = text;
                          },
                          decoration: InputDecoration(
                            hintText: '별명을 입력해주세요',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(width: 1, color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.grey),
                            ),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                        child: FilledButton(onPressed: () async{
                          try {
                            await _userRepository.createUser(_account?.name ?? '');
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder:
                                    (context) =>
                                    StoreRegisterPage()
                                ),
                                    (route) => false
                            );
                          } catch (e) {
                            AppToast.showToast("회원가입에 실패했습니다.");
                            print(e);
                          }
                        },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColor().mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text("다음 ( 1 / 2 )",
                            style: TextStyle(fontSize: 17,color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(),
                  ],
                ),
              );
            }
          }
        )
    );
  }
}