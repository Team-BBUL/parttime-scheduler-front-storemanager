import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/main.dart';
import 'package:sidam_storemanager/utils/app_color.dart';
import 'package:sidam_storemanager/view/store_register_page.dart';
import 'package:sidam_storemanager/view_model/local_login_view_model.dart';

class AccountDetailsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailsState();
}

class _DetailsState extends State<AccountDetailsScreen> {

  AppColor color = AppColor();

  bool check = true;
  bool idCheck = true;
  bool pwCheck = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
          '회원 정보 등록',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: Consumer<LocalLoginViewModel>(builder: (context, state, child) {
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
                                labelText: '이름',
                                labelStyle:
                                const TextStyle(color: Colors.black26),
                              ),
                              controller: _nameController,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return '이름 입력해주세요!';
                                }
                                if (value!.length > 10) {
                                  return '이름 10자를 초과할 수 없습니다!';
                                }
                                if (value.length < 2) {
                                  return '이름이 너무 짧습니다.';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp(r'[ㄱ-ㅎ가-힣]'),
                                  allow: true,
                                )
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
                        log('이름: ${_nameController.text}');

                        state.setAccountData(_nameController.text)
                            .then((value) {
                              state.init = true;
                          if (state.inStore){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyHomePage(title: 'Home')));
                          } else {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => StoreRegisterPage()));
                          }
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
                      '저장',
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
