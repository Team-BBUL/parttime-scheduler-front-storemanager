import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/app_color.dart';
import '../utils/app_input_theme.dart';
import '../utils/app_picker_sheet.dart';
import '../view_model/store_register_view_model.dart';

class StoreRegisterScreen extends StatelessWidget{
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreRegisterViewModel>(
        builder:(context, viewModel,child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(flex: 8, child: Container()),
                                    Flexible(flex: 3,
                                        child: Container(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder:
                                                    (context) => MyHomePage(title: '')
                                                ),
                                              );
                                            },
                                            child: Text('넘어가기'),),
                                        ))
                                  ],
                                ),
                                TextFormField(
                                  validator: viewModel.storeValidator.validateName,
                                  onChanged: (_) => (viewModel.setTextFieldChanged()),
                                  controller: nameController,
                                  decoration: AppInputTheme().registerDecoration(hint: '매장명'),
                                  keyboardType: TextInputType.text,
                                ),
                                if(viewModel.errorMessage.containsKey('name')
                                    && !viewModel.isTextFieldChanged)
                                  Text(
                                    viewModel.errorMessage['name']!,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                TextFormField(
                                  validator: viewModel.storeValidator.validateLocation,
                                  onChanged: (_) => (viewModel.setTextFieldChanged()),
                                  controller: locationController,
                                  decoration: AppInputTheme().registerDecoration(hint: '매장 위치'),
                                  keyboardType: TextInputType.text,
                                ),
                                TextFormField(
                                  validator: viewModel.storeValidator.validatePhone,
                                  onChanged: (_) => (viewModel.setTextFieldChanged()),
                                  controller: phoneController,
                                  decoration: AppInputTheme().registerDecoration(hint: '매장 전화번호'),
                                  keyboardType:       TextInputType.text,
                                ),

                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                                child: AppPickerSheet().customCupertinoPicker(
                                                  indicator: "시",
                                                  setTime : viewModel.setOpenTime,
                                                  selected: viewModel.store?.open ?? 0,
                                                  times : viewModel.time,
                                                )
                                            ),
                                            Expanded(
                                                child: AppPickerSheet().customCupertinoPicker(
                                                  indicator: "시",
                                                  setTime: viewModel.setClosedTime,
                                                  selected: viewModel.store?.closed ?? 0,
                                                  times: viewModel.time,
                                                )
                                            )
                                          ],
                                        );
                                      }
                                  ),
                                  child: TextFormField(
                                    validator: viewModel.storeValidator.validateTime,
                                    enabled: false,
                                    controller: viewModel.timeController,
                                    decoration: AppInputTheme().registerDecoration(hint: '매장 운영 시간'),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AppPickerSheet().customCupertinoPicker(
                                            indicator: '일',
                                            setTime : viewModel.setPayday,
                                            selected: (viewModel.store?.payday) == null
                                                ? 0
                                                : viewModel.store!.payday! - 1,
                                            times : viewModel.day);
                                      }),
                                  child: TextFormField(
                                    validator: viewModel.storeValidator.validatePayday,
                                    enabled: false,
                                    controller: viewModel.paydayController,
                                    decoration: AppInputTheme().registerDecoration(hint: '급여 지급일'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AppPickerSheet()
                                            .weekdayPicker(
                                            context,
                                            "근무표 시작 날짜",
                                            viewModel
                                                .store?.startDayOfWeek,
                                            viewModel
                                                .setStartDayOfWeek);
                                      }),
                                  child: TextFormField(
                                    validator: viewModel.storeValidator.validateStartDayOfWeek,
                                    enabled: false,
                                    controller: viewModel.startDayOfWeekController,
                                    decoration: AppInputTheme().registerDecoration(hint: '근무표 시작 날짜'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AppPickerSheet()
                                            .weekdayPicker(
                                            context,
                                            "근무 불가능 시간 선택 마감일",
                                            viewModel
                                                .store?.deadlineOfSubmit,
                                            viewModel
                                                .setDeadlineOfSubmit);
                                      }),
                                  child: TextFormField(
                                    validator: viewModel.storeValidator.validateDeadlineOfSubmit,
                                    enabled: false,
                                    controller: viewModel.deadlineOfSubmitController,
                                    decoration: AppInputTheme().registerDecoration(hint: '근무 불가능 시간 선택 마감일'),
                                  ),
                                ),
                                // StoreTextForm(viewModel, '근무자 초대', TextInputType.text),
                              ],
                            )
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(40.0, 80.0, 40.0, 10),
                          child: FilledButton(
                            onPressed: () => ({
                              if (_formKey.currentState!.validate()) {
                                viewModel.setStoreInfo(
                                  name : nameController.text,
                                  location : locationController.text,
                                  phone : phoneController.text,
                                ),
                                viewModel.sendStoreInfo(context)
                              },
                            }),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColor().mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text("진행",
                              style: TextStyle(fontSize: 17,color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),

            )
          );
        }
    );
  }
}