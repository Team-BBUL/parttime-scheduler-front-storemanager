import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_input_theme.dart';
import 'package:sidam_storemanager/utils/dialog_message.dart';
import 'package:sidam_storemanager/view/cost_policy.dart';
import 'package:sidam_storemanager/view/employee_details.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

import '../utils/app_color.dart';
import '../utils/app_future_builder.dart';
import '../utils/app_picker_sheet.dart';

class StoreManagementScreen extends StatelessWidget {
  const StoreManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final viewModel = Provider.of<StoreManagementViewModel>(context,listen: false );

    return AppFutureBuilder(
        future: viewModel.getStoreManagementScreenData(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('매장 정보'),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.check_box),
                    tooltip: 'Go to the next page',
                    onPressed: () {
                      Message().showConfirmDialog(
                        context: context,
                        title: "스토어 정보를 수정하시겠습니까?",
                        message: "수정하시겠습니까?",
                        apiCall: () => viewModel.sendStoreManagementScreenData(),
                        popCount: 2,
                      );
                    },
                  ),
                ],
              ),
              body: Consumer<StoreManagementViewModel>(
                builder: (context, viewModel, child){
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: AppInputTheme().marginSpace(),
                              child: TextField(
                                decoration: AppInputTheme()
                                    .buildDecoration(borderText: "매장 이름", writable: true),
                                enabled: true,
                                onChanged: (text) =>
                                    viewModel.setStoreName(text),
                                controller: TextEditingController(
                                    text: viewModel.store?.name ?? ''),
                              )),
                          Container(
                              margin: AppInputTheme().marginSpace(),
                              child: TextField(
                                  decoration: AppInputTheme()
                                      .buildDecoration(borderText: "매장 위치", writable: true),
                                  enabled: true,
                                  onChanged: (text) =>
                                      viewModel.setLocation(text),
                                  controller: TextEditingController(
                                      text: viewModel.store?.location ?? '')
                              )),
                          Container(
                            margin: AppInputTheme().marginSpace(),
                            child: InputDecorator(
                                decoration: AppInputTheme().buildDecoration(
                                    borderText: "매장 운영 시간", writable: true),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: GestureDetector(
                                              onTap: () => showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AppPickerSheet().customCupertinoPicker(
                                                        indicator: '시',
                                                        setTime : viewModel.setOpenTime,
                                                        selected: viewModel.store?.open ?? 0,
                                                        times: viewModel.time);
                                                  }),
                                              child: Text('개점 ${viewModel.store?.open ?? 0} 시',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black)),
                                            ))),
                                    Expanded(
                                        child: Center(
                                            child: GestureDetector(
                                              onTap: () => showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AppPickerSheet().customCupertinoPicker(
                                                        indicator: '시',
                                                        setTime : viewModel.setCloseTime,
                                                        selected: viewModel.store?.closed ?? 0,
                                                        times: viewModel.time);
                                                  }),
                                              child: Text('매점  ${viewModel.store?.closed ?? 0} 시',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black)),
                                            ))),
                                  ],
                                )),
                          ),

                          Expanded(
                              flex: 0,
                              child: Container(
                                  margin: AppInputTheme().marginSpace(),
                                  child: InputDecorator(
                                    decoration: AppInputTheme().buildDecoration(
                                        borderText: "근무 시간 관리", writable: false),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text('근무표 시작 날짜',
                                                  style: TextStyle(fontSize: 16)),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: TextButton(
                                                  onPressed: () => showModalBottomSheet(
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
                                                  child: Text(
                                                      viewModel.store?.startDayOfWeek ==
                                                          0
                                                          ? '선택안됨'
                                                          : '매주 ${viewModel.store?.convertWeekdayToKorean(
                                                          viewModel.store?.startDayOfWeek)}요일',
                                                      style: TextStyle(fontSize: 16))),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text('근무 불가능 시간 선택 마감일',
                                                  style: TextStyle(fontSize: 16)),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: TextButton(
                                                  onPressed: () => showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AppPickerSheet().weekdayPicker(
                                                            context,
                                                            "근무 불가능 시간 선택 마감일",
                                                            viewModel.store
                                                                ?.deadlineOfSubmit,
                                                            viewModel
                                                                .setDeadlineOfSubmit);
                                                      }),
                                                  child: Text(
                                                      viewModel.store
                                                          ?.deadlineOfSubmit ==
                                                          0
                                                          ? '선택안됨'
                                                          : '매주 ${viewModel.store?.convertWeekdayToKorean(
                                                          viewModel.store?.deadlineOfSubmit)}요일',
                                                      style: TextStyle(fontSize: 16))),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))),
                          Container(
                              margin: AppInputTheme().marginSpace(),
                              child: InputDecorator(
                                  decoration: AppInputTheme()
                                      .buildDecoration(borderText: "월급일", writable: true),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: GestureDetector(
                                          onTap: () => showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AppPickerSheet().customCupertinoPicker(
                                                    indicator: '일',
                                                    setTime : viewModel.setPayday,
                                                    selected : (viewModel.store?.payday)! - 1,
                                                    times : viewModel.day);
                                              }),
                                          child: Text(
                                              viewModel.store?.payday == null ?
                                              '선택안됨'
                                                  :
                                              '매월  ${
                                                  viewModel.store?.payday == 31
                                                      ? '말'
                                                      :
                                                  viewModel.store?.payday} 일',
                                              style: const TextStyle(
                                                fontSize: 16,)),
                                        ),
                                      ),
                                    ],
                                  ))),
                          Expanded(
                            flex: 0,
                            child: Container(
                              margin: AppInputTheme().marginSpace(),
                              child: InputDecorator(
                                  decoration: AppInputTheme().buildDecoration(
                                      borderText: "근무자 관리", writable: false),
                                  child: Column(
                                    children: [
                                      Container(
                                        // color: Colors.grey[100],
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text('레벨',
                                                  style: TextStyle(fontSize: 16,  color: Colors.grey)),
                                            ),
                                            const Expanded(
                                              child: Text('이름',
                                                  style: TextStyle(fontSize: 16, color: Colors.grey)),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: viewModel.employees == null
                                            ? []
                                            : viewModel.employees!
                                            .map((employee) => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Text("${employee.level}",
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            ),
                                            Expanded(
                                              child: Text("${employee.alias}",
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () async {
                                                  await viewModel.getEmployee(employee.id!);
                                                  await viewModel.getAnniversary(
                                                      employee.id!);
                                                  await viewModel.getIncentiveList(employee.id!);
                                                  Navigator.push(context,
                                                      MaterialPageRoute<void>(
                                                          builder: (context) {
                                                            return EmployeeDetailScreen();
                                                          }));
                                                },
                                              ),
                                            )
                                          ],
                                        )).toList(),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: Container(
                                margin: AppInputTheme().marginSpace(),
                                child: InputDecorator(
                                  decoration: AppInputTheme().buildDecoration(
                                      borderText: "월간 시급 보너스 데이", writable: true),
                                  child:
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: '보너스 이름'
                                                ),
                                                enabled: true,
                                                onChanged: (text) =>
                                                    viewModel.setPolicyDescription(text),

                                              )),
                                          ElevatedButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AppPickerSheet().customCupertinoPicker(
                                                      indicator: '배',
                                                      setTime : viewModel.setMultiplyValue,
                                                      selected : ((viewModel.newCostPolicy?.multiplyCost ?? 0) * 10 - 11).round(),
                                                      times : viewModel.multiplies);
                                                });
                                              },
                                            child: Text('${viewModel.newCostPolicy!.multiplyCost ?? 2.0} 배',

                                                style: const TextStyle(
                                                  fontSize: 16, color: Colors.black)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AppPickerSheet().customCupertinoPicker(
                                                        indicator: '일',
                                                        setTime : viewModel.setCostPolicyDate,
                                                        selected : (
                                                            (viewModel.newCostPolicy?.day) == null ? 0
                                                            :
                                                        (viewModel.newCostPolicy?.day)! - 1 ) ,
                                                        times : viewModel.costPolicyDays);
                                                  });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    viewModel.newCostPolicy?.day == null
                                                        ? "날짜"
                                                        : "${viewModel.newCostPolicy?.day}일",
                                                    style: const TextStyle(
                                                        fontSize: 16, color: Colors.black)),
                                                const SizedBox(width: 8),
                                                const Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Message().showConfirmDialog(
                                                  context: context,
                                                  title: "급여 정책을 추가하시겠습니까?",
                                                  message: "",
                                                  apiCall: () => viewModel.createPolicy(),
                                                  popCount: 1);
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: viewModel.policyList == null
                                            ? []
                                            : viewModel.policyList!
                                            .map((policy) => Row(
                                          children: [
                                            Expanded(
                                              child: Text("${policy.description}",
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            ),
                                            Expanded(
                                              child: Text("${policy.multiplyCost} 배",
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            ),
                                            Expanded(
                                              child: Text("${policy.day} 일",
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () async {
                                                Message().showConfirmDialog(
                                                    context: context,
                                                    title: "일간 시급 보너스 데이를 삭제하시겠습니까?",
                                                    message: "",
                                                    apiCall: () => viewModel
                                                        .removePolicy(policy.id!),
                                                    popCount: 1);
                                              },
                                            )
                                          ],
                                        ))
                                            .toList(),
                                      ),

                                    ],
                                  )


                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                },
              )
          );
      });
  }
}
