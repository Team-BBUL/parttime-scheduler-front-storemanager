import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/dialog_message.dart';
import 'package:sidam_storemanager/utils/horizontal_line.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

import '../utils/app_color.dart';
import '../utils/app_input_theme.dart';
import '../utils/app_picker_sheet.dart';

class EmployeeRegisterScreen extends StatelessWidget {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _checkPWController = TextEditingController();
  final _nameController = TextEditingController();

  final _textFormFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StoreManagementViewModel>(context,listen: false );
    viewModel.initEmployeeRegisterScreen();
    return Consumer<StoreManagementViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
              appBar: AppBar(
                title : Text('근무자 등록'),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.check_box),
                    tooltip: 'Go to the next page',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()  || viewModel.idStatusCode == '2002' ) {
                        await viewModel.checkAccountId(_idController.text);
                        if(viewModel.idStatusCode == '2001'){
                          Message().showConfirmDialog(
                              context: context,
                              title: "근무자를 등록하시겠습니까?",
                              message: "message",
                              apiCall:  () =>
                                  viewModel.createNewEmployee(
                                      _idController.text,
                                      _pwController.text,
                                      _nameController.text,
                                  ),
                              popCount: 2
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                            children: [
                          Container(
                              margin: AppInputTheme().marginSpace(),
                              child: Row(
                                  children: [
                                    Expanded(
                                      child:  TextFormField(
                                        key: _textFormFieldKey,
                                        decoration: AppInputTheme().buildSuffixIcon(
                                          borderText: "아이디",
                                          writable: true,
                                          pressed:  () async=>
                                               ({
                                            if(_textFormFieldKey.currentState!
                                                .validate() || viewModel.idStatusCode == '2002'){
                                              await viewModel.checkAccountId(_idController.text)
                                            }
                                          }),
                                          errorMsg: viewModel.idStatusCode == '2002' ? "아이디가 중복되었습니다" : null,

                                        ),
                                        controller: _idController,
                                        validator:  (String? value){
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
                                      ),
                                    ),
                                  ]
                              ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              margin: AppInputTheme().marginSpace(),

                              child: TextFormField(
                                decoration: AppInputTheme().buildDecoration(
                                    borderText: "비밀번호", writable: true),
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
                          Container(
                              margin: AppInputTheme().marginSpace(),
                              child: TextFormField(
                                decoration: AppInputTheme().buildDecoration(
                                    borderText: "비밀번호 확인", writable: true),
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
                              HorizontalLine(label: "기본정보", height: 30),
                              Container(
                                  margin: AppInputTheme().marginSpace(),
                                  child: TextFormField(
                                    decoration: AppInputTheme().buildDecoration(
                                        borderText: "근무자 이름", writable: true),
                                    controller: _nameController,
                                    validator: (String? value) {
                                      if (value?.isEmpty ?? true) {
                                        return '이름은 필수항목입니다';
                                      }
                                      if (value!.length > 10) {
                                        return '이름은 10자를 초과할 수 없습니다!';
                                      }
                                      if (value.length < 2) {
                                        return '이름이 너무 짧습니다.';
                                      }
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                          RegExp(r'[a-zA-Z0-9.,!@#$%^&*=+-]'),
                                          allow: true),
                                    ],
                                  )),
                              Container(
                                  margin: AppInputTheme().marginSpace(),
                                  child: InputDecorator(
                                      decoration: AppInputTheme().buildDecoration(
                                          borderText: "급여 방식 구분", writable: true),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              if(viewModel.newEmployee?.salary != null)
                                                Text(
                                                    viewModel.newEmployee!.salary!
                                                        ? '월급'
                                                        : '시급',
                                                    style: TextStyle(fontSize: 16)),
                                              IconButton(
                                                icon: const Icon(Icons.arrow_drop_down_outlined),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return _Salarydialog(
                                                          context, viewModel);
                                                    },
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              if(viewModel.newEmployee?.salary != null)
                                                Text(
                                                    viewModel.newEmployee!.salary!
                                                        ? '월급'
                                                        : '시간당 ',
                                                    style: TextStyle(fontSize: 16)),
                                              Expanded(
                                                child: TextFormField(
                                                  textAlign: TextAlign.right,
                                                  enabled: true,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.digitsOnly
                                                  ],
                                                  // Only numbers can
                                                  validator: (String? value) {
                                                    if (value?.isEmpty ?? true) {
                                                      return '급여는 필수항목입니다';
                                                    }
                                                  },
                                                  onChanged: (text) =>
                                                      viewModel.setNewCost(text),
                                                  controller: TextEditingController(
                                                      text:
                                                      '${viewModel.newEmployee?.cost ?? ''}'),
                                                ),
                                              ),
                                              Expanded(
                                                child:
                                                Text('원', style: TextStyle(fontSize: 16)),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                  )
                              ),
                        ])),
                    Container(
                        margin: AppInputTheme().marginSpace(),
                        child: InputDecorator(
                          decoration: AppInputTheme()
                              .buildDecoration(borderText: "레벨", writable: true),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AppPickerSheet().customCupertinoPicker(
                                        indicator: '레벨',
                                        setTime : viewModel.setNewLevel,
                                        selected : (viewModel.newEmployee?.level) ?? 0,
                                        times : viewModel.levels);
                                  }),
                              child: Text(
                                  "${viewModel.newEmployee?.level ?? '0'} 레벨",
                                  style: const TextStyle(
                                    fontSize: 16,)),
                            ),
                          ),
                        )),
                  ],
                ),
              ));
        });
  }

  Widget _Salarydialog(context,StoreManagementViewModel viewModel) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('시급', style: TextStyle(fontSize: 16)),
                      if (!viewModel.newEmployee!.salary!)
                        Icon(
                          Icons.check,
                          color: AppColor().blackColor,
                        )
                      else
                        const Icon(null)
                    ]),
              ),
              onTap: () {
                viewModel.setNewIsSalary(false);
                Navigator.pop(context);
              },
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('월급', style: TextStyle(fontSize: 16)),
                      if (viewModel.newEmployee!.salary!)
                        Icon(
                          Icons.check,
                          color: AppColor().blackColor,
                        )
                      else
                        const Icon(null)
                    ]),
              ),
              onTap: () {
                viewModel.setNewIsSalary(true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
