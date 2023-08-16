import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/view/home.dart';

import '../main.dart';
import '../utils/app_color.dart';
import '../utils/app_picker_sheet.dart';
import '../utils/app_toast.dart';
import '../utils/dialog_message.dart';
import '../view_model/store_register_view_model.dart';
import '../utils/custom_cupertino_picker.dart';

class StoreRegisterScreen extends StatelessWidget{
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final openController = TextEditingController();
  final paydayController = TextEditingController();
  final weekStartDayController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreRegisterViewModel>(
        builder:(context, viewModel,child) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0, 0),
                    child: Row(
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
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: Column(
                        children: [
                          StoreTextForm(viewModel, nameController, '매장명', TextInputType.text),
                          if(viewModel.errorMessage.containsKey('name')
                              && !viewModel.isTextFieldChanged)
                            Text(
                              viewModel.errorMessage['name']!,
                              style: TextStyle(color: Colors.red),
                            ),
                          StoreTextForm(viewModel, locationController, '매장위치', TextInputType.text),
                          StoreTextForm(viewModel, phoneController, '매장 전화번호', TextInputType.text),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                          child: AppPickerSheet().customCupertinoPicker(
                                            "시",
                                            viewModel.setOpenTime,
                                            viewModel.store?.open ?? 0,
                                            viewModel.time,
                                          )
                                      ),
                                      Expanded(
                                          child: AppPickerSheet().customCupertinoPicker(
                                            "시",
                                            viewModel.setCloseTime,
                                            viewModel.store?.close ?? 0,
                                            viewModel.time,
                                          )
                                      )
                                    ],
                                  );
                                }
                            ),
                            child: TextField(
                              enabled: false,
                              controller: viewModel.timeController,
                              decoration: const InputDecoration(
                                hintText: '매장 운영 시간',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          StoreTextForm(viewModel, paydayController, '급여 지급일', TextInputType.text),
                          StoreTextForm(viewModel, weekStartDayController, '주차 시작일', TextInputType.text),

                          // StoreTextForm(viewModel, '근무자 초대', TextInputType.text),

                        ],
                      )
                  ),
                  Flexible(
                      flex: 4,
                      child: Column(
                        children: [
                          Flexible(child: Container()),
                          Flexible(child: Container()),
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                                child: FilledButton(
                                  onPressed: () => ({
                                    viewModel.setStoreInfo(
                                        nameController.text,
                                        locationController.text,
                                        phoneController.text,
                                        int.tryParse(paydayController.text) ??
                                            -1,
                                        int.tryParse(
                                            weekStartDayController.text) ?? -1
                                    ),
                                    viewModel.sendStoreInfo(context)
                                  }),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColor().mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Text("진행",
                                    style: TextStyle(fontSize: 17,color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          );
        }
    );

  }

  Widget StoreTextForm(StoreRegisterViewModel viewModel,
      TextEditingController namedController, String hint, TextInputType type){
    return TextField(
      onChanged: (_) => (viewModel.setTextFieldChanged()),
      controller: namedController,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}