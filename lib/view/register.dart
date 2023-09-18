import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_color.dart';
import 'package:sidam_storemanager/view_model/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {

  AppColor color = AppColor();

  bool check = true;
  bool idCheck = true;
  bool pwCheck = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _pwController;
  late TextEditingController _checkPWController;

  @override
  void initState() {
    super.initState();

    _idController = TextEditingController();
    _pwController = TextEditingController();
    _checkPWController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _checkPWController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: color.mainColor,
        title: const Text(
          '회원가입',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: Consumer<RegisterViewModel>(builder: (context, state, child) {
        if (!state.loading) {
          return SizedBox(
          height: deviceHeight - 50,
          width: deviceWidth,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: formKey,
                    child: Column(children: [
                      SizedBox(
                          width: 300,
                          height: 65,
                          child: TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: color.mainColor),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'ID',
                              labelStyle:
                                  const TextStyle(color: Colors.black26),
                            ),
                            controller: _idController,
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return 'ID를 입력해주세요!';
                              }
                              if (value!.length > 20) {
                                return 'ID는 20자를 초과할 수 없습니다!';
                              }
                              if (value.length < 3) {
                                return 'ID가 너무 짧습니다.';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                RegExp(r'[a-zA-z0-9]'),
                                allow: true,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: 300,
                          height: 65,
                          child: TextFormField(
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: color.mainColor),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: '비밀번호',
                                labelStyle:
                                    const TextStyle(color: Colors.black26)),
                            controller: _pwController,
                            obscureText: true,
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return '비밀번호를 입력해주세요!';
                              }
                              if (value!.length > 50) {
                                return '비밀번호는 50자를 초과할 수 없습니다!';
                              }
                              if (value.length < 8) {
                                return '비밀번호가 너무 짧습니다.';
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9.,!@#$%^&*=+-]'),
                                  allow: true),
                            ],
                          )),
                      SizedBox(
                          width: 300,
                          height: 65,
                          child: TextFormField(
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: color.mainColor),
                                ),
                                floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                                labelText: '비밀번호 확인',
                                labelStyle:
                                const TextStyle(color: Colors.black26)),
                            controller: _checkPWController,
                            obscureText: true,
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return '비밀번호를 입력해주세요!';
                              }
                              if (value!.length > 50) {
                                return '비밀번호는 50자를 초과할 수 없습니다!';
                              }
                              if (value.length < 8) {
                                return '비밀번호가 너무 짧습니다.';
                              }
                              if(value != _pwController.text) {
                                return '비밀번호가 일치하지 않습니다.';
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9.,!@#$%^&*=+-]'),
                                  allow: true),
                            ],
                          )),
                    ])),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () async {
                    bool validationResult = true;

                    setState(() {
                      validationResult =
                          formKey.currentState?.validate() ?? false;
                    });

                    if (validationResult) {
                      log('유효성 검사 통과');
                      log('id: ${_idController.text}\npw: ${_pwController.text}');

                      state.fetchRegister(_idController.text, _pwController.text)
                        .then((value) {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                            backgroundColor: Colors.white,
                            content: Text(state.message),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.of(context).pop();
                                if (state.success) {
                                  Navigator.of(context).pop();
                                  /*Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => AccountDetailsScreen())
                                  );*/
                                }
                              }, child: Text('확인', style: TextStyle(color: color.mainColor),))
                            ],
                          );
                        });
                      });

                    } else {
                      log('유효성 검사 실패');
                    }
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(200, 30),
                    backgroundColor: color.mainColor,
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
        );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(color: color.mainColor,),
            ),
          );
        }
      })),
    );
  }
}
