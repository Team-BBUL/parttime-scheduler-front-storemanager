import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/dialog_message.dart';
import 'package:sidam_storemanager/utils/horizontal_line.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

import '../model/Incentive.dart';
import '../model/anniversary.dart';
import '../utils/app_color.dart';
import '../utils/app_input_theme.dart';
import '../utils/app_picker_sheet.dart';

class EmployeeDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreManagementViewModel>(
        builder: (context, viewModel, child) {
      return Scaffold(
          appBar: AppBar(
            title :
            viewModel.selectedEmployee?.id != null ?
              Text('근무자 정보 ')
            :
              Text('근무자 등록'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.check_box),
                tooltip: 'Go to the next page',
                onPressed: () {
                  Message().showConfirmDialog(
                      context: context,
                      title: "회원정보를 수정하시겠습니까?",
                      message: "message",
                      apiCall:  () => viewModel.sendEmployeeScreenData(),
                      popCount: 2
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(viewModel.selectedEmployee?.id != null)
                HorizontalLine(label: "필수정보", height: 30),
                // Container(
                //     margin: AppInputTheme().marginSpace(),
                //     child: TextField(
                //         decoration: AppInputTheme().buildDecoration(
                //             borderText: "근무자 닉네임", writable: true),
                //         enabled: false,
                //         controller: TextEditingController(
                //             text: viewModel.selectedEmployee?.account?.name ?? ''))),

                Container(
                    margin: AppInputTheme().marginSpace(),
                    child: TextField(
                      decoration: AppInputTheme().buildDecoration(
                          borderText: "근무자 이름", writable: false),
                      enabled: false,
                      onChanged: (text) =>
                          viewModel.setAlias(text),
                      controller: TextEditingController(
                          text: viewModel.selectedEmployee?.alias ?? ''),
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
                                if(viewModel.selectedEmployee?.salary != null)
                                  Text(
                                      viewModel.selectedEmployee!.salary!
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
                                if(viewModel.selectedEmployee?.salary != null)
                                  Text(
                                    viewModel.selectedEmployee!.salary!
                                        ? '월급'
                                        : '시간당 ',
                                    style: TextStyle(fontSize: 16)),
                                Expanded(
                                  child: TextField(
                                    textAlign: TextAlign.right,
                                    enabled: true,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    // Only numbers can
                                    onChanged: (text) =>
                                        viewModel.setCost(text),
                                    controller: TextEditingController(
                                        text:
                                        '${viewModel.selectedEmployee?.cost ?? ''}'),
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
                                          setTime : viewModel.setLevel,
                                          selected : (viewModel.selectedEmployee?.level) ?? 0,
                                          times : viewModel.levels);
                                    }),
                                child: Text(
                                    "${viewModel.selectedEmployee?.level ?? '0'} 레벨",
                                    style: const TextStyle(
                                      fontSize: 16,)),
                              ),
                            ),
                    )),
                ExpansionTile(
                  textColor: Colors.black,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("기본 아이디/ 비밀번호"),
                        TextButton(
                            onPressed: () async {
                              Clipboard.setData(
                                  ClipboardData(
                                      text: '아이디 : ${
                                          viewModel.selectedEmployee?.account?.originAccountId ?? ''}'
                                          '\n비밀번호 : ${viewModel.selectedEmployee?.account?.originPassword}')
                              );
                              ClipboardData? data = await Clipboard.getData('text/plain');
                              if(data?.text != null && data?.text?.substring(0,3) == '아이디'){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('복사 되었습니다!'),
                                      duration: Duration(seconds: 3),
                                    )
                                );
                              }
                            },
                            child: Text("복사")
                        )
                      ],
                    ),
                  children: [
                    Container(
                        margin: AppInputTheme().marginSpace(),
                        child: TextField(
                          decoration: AppInputTheme().buildDecoration(
                              borderText: "기본 아이디", writable: false),
                          enabled: false,

                          controller: TextEditingController(
                              text: viewModel.selectedEmployee?.account?.originAccountId ?? ''),
                        )),
                    Container(
                        margin: AppInputTheme().marginSpace(),
                        child: TextField(
                          decoration: AppInputTheme().buildDecoration(
                              borderText: "기본 비밀번호", writable: false),
                          enabled: false,

                          controller: TextEditingController(
                              text: viewModel.selectedEmployee?.account?.originPassword ?? ''),
                        )),
                  ],
                ),
                Column(
                  children: [
                    HorizontalLine(label: "추가정보", height: 30),
                    Container(
                      margin: AppInputTheme().marginSpace(),
                      child: InputDecorator(
                          decoration: AppInputTheme()
                              .buildDecoration(borderText: "기념일", writable: true),
                          child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(hintText: "기념일 이름"),
                                          enabled: true,
                                          onChanged: (text) =>
                                              viewModel.setAnniversaryName(text),
                                        )),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime.now(),
                                          locale: const Locale('ko', 'KO'),
                                        );
                                        if (selectedDate != null) {
                                          viewModel.setDate(selectedDate);
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              viewModel.date == null
                                                  ? "선택"
                                                  : "${viewModel.date?.month}월 ${viewModel.date?.day}일",
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
                                            title: "기념일을 추가하시겠습니까?",
                                            message: "",
                                            apiCall: () => viewModel.createAnniversary(),
                                            popCount: 1);
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: viewModel.anniversaries == null
                                      ? []
                                      : viewModel.anniversaries!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    Anniversary anniversary = entry.value;
                                    return Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                              enabled: false,
                                              controller: TextEditingController(
                                                  text: '${anniversary.name}'),
                                              style: TextStyle(fontSize: 16)),
                                        ),
                                        Container(
                                          child: Text(
                                              '${anniversary.date!.month}월 .${anniversary.date!.day}일',
                                              style: TextStyle(fontSize: 16)),
                                        ),
                                        Icon(null),
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () async {
                                            Message().showConfirmDialog(
                                                context: context,
                                                title: "기념일을 삭제하시겠습니까?",
                                                message: "message",
                                                apiCall: () => viewModel
                                                    .removeAnniversary(viewModel.anniversaries![index].id!),
                                                popCount: 1);
                                          },
                                        )
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ])),
                    ),
                    Container(
                      margin: AppInputTheme().marginSpace(),
                      child: InputDecorator(
                          decoration: AppInputTheme()
                              .buildDecoration(borderText: "인센티브", writable: true),
                          child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: "지급 내용",
                                          ),
                                          enabled: true,
                                          onChanged: (text) =>
                                              viewModel.setDescription(text),
                                          controller: TextEditingController(
                                              text:
                                              '${viewModel.newIncentive?.description ?? ''}'
                                          ),
                                        )
                                    ),
                                    VerticalDivider(
                                      width: 10,
                                      thickness: 1,
                                      color: Colors.black,),
                                    Expanded(
                                      child:  TextField(
                                        decoration: const InputDecoration(
                                          hintText: "금액",
                                        ),
                                        textAlign: TextAlign.right,
                                        enabled: true,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        // Only numbers can
                                        onChanged: (text) =>
                                            viewModel.setIncentiveCost(text),
                                        controller: TextEditingController(
                                            text:
                                            '${viewModel.newIncentive?.cost ?? ''}'
                                        ),
                                      ),
                                    ),
                                    Text("원"),
                                    VerticalDivider(
                                      width: 10,
                                      thickness: 1,
                                      color: Colors.black,),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime.now(),
                                          locale: const Locale('ko', 'KO'),
                                        );
                                        if (selectedDate != null) {
                                          viewModel.setIncentiveDate(selectedDate);
                                        }
                                      },
                                      child:  Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              viewModel.newIncentive?.date == null
                                                  ? "선택"
                                                  : "${viewModel.newIncentive?.date?.month}월 "
                                                  "${viewModel.newIncentive?.date?.day}일",
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
                                            title: "인센티브를 추가하시겠습니까?",
                                            message: "",
                                            apiCall: () => viewModel.postIncentive(),
                                            popCount: 1);
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: viewModel.monthIncentiveList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    // YearMonth yearMonth = viewModel.monthIncentiveList!.keys.elementAt(index);
                                    String yearMonth = viewModel.monthIncentiveList?.keys.elementAt(index) ?? '0';
                                    List<Incentive>? incentives = viewModel.monthIncentiveList?[yearMonth]!;
                                    String year = yearMonth.substring(0, 4);
                                    String month;
                                    if(yearMonth.length == 5)
                                      month = yearMonth.substring(4, 5);
                                    else
                                      month = yearMonth.substring(5, 7);
                                    return ExpansionTile(
                                      textColor: Colors.black,
                                      title: Text('${year}년 ${month}월 인센티브'),
                                      children: incentives!.map((Incentive incentive) => ListTile(
                                        title: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${incentive.description}"),
                                            Text(" ${incentive.cost}원"),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          tooltip: 'Go to the next page',
                                          onPressed: () {
                                            Message().showConfirmDialog(
                                                context: context,
                                                title: '인센티브 삭제',
                                                message: '삭제하시겠습니까?',
                                                apiCall: () => viewModel.deleteIncentive(incentive.id!, viewModel.selectedEmployee!.id!),
                                                popCount: 1);
                                          },
                                        ),
                                        subtitle: Text(" ${incentive.date!.day}일 ${incentive.koreanWeekday()}요일"),
                                      )).toList(),
                                    );
                                  },
                                ),
                              ])),
                    ),

                  ],
                )
              ],
            ),
          ));
    });
  }

  Widget _Salarydialog(context, viewModel) {
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
                      if (!viewModel.selectedEmployee?.salary!)
                        Icon(
                          Icons.check,
                          color: AppColor().blackColor,
                        )
                      else
                        const Icon(null)
                    ]),
              ),
              onTap: () {
                viewModel.setIsSalary(false);
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
                      if (viewModel.selectedEmployee!.salary!)
                        Icon(
                          Icons.check,
                          color: AppColor().blackColor,
                        )
                      else
                        const Icon(null)
                    ]),
              ),
              onTap: () {
                viewModel.setIsSalary(true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
