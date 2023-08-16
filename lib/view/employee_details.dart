import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/dialog_message.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

import '../model/account_role.dart';
import '../model/anniversary.dart';
import '../utils/app_input_theme.dart';

class EmployeeDetailScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreManagementViewModel>(
        builder: (context, viewModel, child){
          return Scaffold(
              appBar: AppBar(
                title: const Text('Employee Details Screen'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.check_box),
                    tooltip: 'Go to the next page',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: AppInputTheme().marginSpace(),
                      child: TextField(
                        decoration: AppInputTheme().buildDecoration(
                            borderText: "근무자 이름",
                            writable: true
                        ),
                        enabled: false,
                        controller: TextEditingController(text: viewModel.selectedEmployee?.alias ?? ''),
                      )
                  ),
                  Container(
                      margin: AppInputTheme().marginSpace(),
                      child: TextField(
                        decoration: AppInputTheme().buildDecoration(
                            borderText: "근무자 별명",
                            writable: true
                        ),
                        enabled: false,
                        controller: TextEditingController(text: viewModel.selectedEmployee?.alias ?? ''),
                      )
                  ),
                  Container(
                    margin: AppInputTheme().marginSpace(),
                    child: InputDecorator(
                        decoration: AppInputTheme().buildDecoration(
                            borderText: "기념일", writable: true
                        ),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:  [
                                   Expanded(
                                    child: TextField(
                                      enabled: true,
                                      onChanged: (text) => viewModel.setAnniversaryName(text),
                                    )
                                  ),

                                  ElevatedButton(
                                    onPressed: () async {
                                      final selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                        locale: const Locale('ko', 'KO'),
                                      );
                                      if(selectedDate != null) {
                                        viewModel.setDate(selectedDate);
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          viewModel.date == null
                                              ? "날짜를 선택해주세요"
                                              : "${viewModel.date?.month}월 ${viewModel.date?.day}일",
                                            style: TextStyle(fontSize: 16,color: Colors.black)),
                                        SizedBox(width: 8),
                                        Icon(Icons.calendar_today,color: Colors.black,),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: ()  {
                                       Message().showConfirmDialog(
                                          context: context,
                                          title: "저장하시겠습니까?",
                                          message: "message",
                                          apiCall: () => viewModel.addAnniversary(),
                                         popCount: 1
                                      );
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],

                              ),

                              Column(
                                children:
                                  viewModel.anniversaries == null
                                      ? []
                                      :
                                  viewModel.anniversaries!
                                      .map((e) => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children:  [
                                      const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text('기념일', style: TextStyle(fontSize: 16)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text('3.27', style: TextStyle(fontSize: 16)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () async {
                                          final selectedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now(),
                                            locale: const Locale('ko', 'KO'),
                                          );
                                        },
                                      )
                                    ],
                                  ),).toList(),

                              ),
                              Column(
                                children:
                                viewModel.newAnniversaries == null
                                    ? []
                                    :
                                viewModel.newAnniversaries!
                                .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  Anniversary anniversary = entry.value;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children:  [
                                     Expanded(
                                      child: TextField(
                                        enabled: false,
                                        controller: TextEditingController(text: '${anniversary.name}'),
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                     Container(
                                      child: Text(
                                          '${anniversary.date!.month}월 .${anniversary.date!.day}일',
                                          style: TextStyle(fontSize: 16)
                                      ),
                                    ),
                                    Icon(null),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () async {

                                      },
                                    )
                                  ],
                                );}).toList(),
                              )
                            ]
                        )
                    ),
                  ),
                  Container(
                      margin: AppInputTheme().marginSpace(),
                      child: TextField(
                        decoration: AppInputTheme().buildDecoration(
                            borderText: "직책",
                            writable: true
                        ),
                        enabled: false,
                        controller: TextEditingController(text: '${viewModel.selectedEmployee?.level ?? ''}'),
                      )
                  ),
                  Container(
                      margin: AppInputTheme().marginSpace(),
                      child: InputDecorator(
                          decoration: AppInputTheme().buildDecoration(
                              borderText: "급여 방식 구분",
                              writable: true),
                          child: Column(
                            children: [
                              Row(
                                children:  [
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('시급', style: TextStyle(fontSize: 16)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Select Text'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: const Text('시급'),
                                                    onTap: () {

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  const Padding(padding: EdgeInsets.all(8.0)),
                                                  GestureDetector(
                                                    child: const Text('월급'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                              Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('시간당 9,620원', style: TextStyle(fontSize: 16)),
                                  ),
                                ],
                              )
                            ],
                          )
                      )
                  ),

                ],
              )
          );
        }
    );
  }

}