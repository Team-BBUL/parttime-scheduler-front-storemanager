import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_future_builder.dart';
import 'package:sidam_storemanager/view_model/cost_view_model.dart';

import '../model/employee_cost.dart';

class CostScreen extends StatelessWidget{
  const CostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainContext = context;
    final viewModel = Provider.of<CostViewModel>(context,listen: false );
    return AppFutureBuilder(
        future: viewModel.loadData(),
        builder: (builder, context){
          return Scaffold(
              body: SafeArea(
                child : Consumer<CostViewModel>(
                    builder:(context, viewModel,child){
                        return viewModel.dateList ==null ?
                          Container(
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("근무표 데이터가 없습니다."),
                                    Text("웹에서 근무표를 등록해주세요.")
                                  ],
                                )
                            ),
                          )
                              :
                        Column(
                            children: [

                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                child: selectDateWidget(viewModel, context),
                              ),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                  child: Row(
                                    children:  [
                                      Expanded(
                                          child:
                                          viewModel.dateIndex == viewModel.dateList!.length -1 ?
                                          Text("이번 달 예상 총 급여 (급여일 기준 : ${viewModel.costDay}일 )")
                                              :
                                          Text("총 지급 급여 (급여일 기준 : ${viewModel.costDay}일 )")
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  child: Row(
                                    children:  [
                                      Expanded(
                                        child: Center(
                                          child: Text('${viewModel.totalPay}원',
                                              style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Center(
                                            child: Text("")
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                            "${viewModel.dateList![viewModel.dateIndex ?? 0]
                                                .subtract(const Duration(days: 30)).month}월 달 보다 "
                                            "${(viewModel.totalPay - viewModel.prevMonthTotalPay >= 0) ?
                                        "${viewModel.totalPay - viewModel.prevMonthTotalPay}원 증가"
                                            :
                                        "${-(viewModel.totalPay - viewModel.prevMonthTotalPay)}원 감소"}"
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                          child:
                                          Text("근무자 별 월급")
                                      ),
                                      Expanded(
                                        child: Text(""),
                                      ),
                                      Expanded(
                                        child: Text(""),
                                      ),
                                    ],
                                  )
                              ),
                              Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child:  box('근무자명',FontWeight.bold),
                                          ),
                                          Expanded(
                                            child:  box('총근무시간',FontWeight.bold),
                                          ),
                                          Expanded(
                                            child:  box('주휴수당',FontWeight.bold),
                                          ),
                                          Expanded(
                                            child:  box('시급',FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          height: 400,
                                          child :  ListView.builder(
                                            itemCount: viewModel.employeesCost!.length,
                                            itemBuilder: (context, index) {
                                              EmployeeCost employeeCost = viewModel.getEmployeeCost(index);
                                              return Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: box(employeeCost.alias,FontWeight.normal),
                                                      ),
                                                      Expanded(
                                                          child: box('${employeeCost.totalWorkTime}h',FontWeight.normal)

                                                      ),
                                                      Expanded(
                                                          child: box('${employeeCost.holidayPay}',FontWeight.normal)

                                                      ),
                                                      Expanded(
                                                          child: box('${employeeCost.hourlyPay}원',FontWeight.normal)
                                                      ),
                                                    ],
                                                  )
                                              );
                                            },
                                          )
                                      ),



                                    ],
                                  )
                              ),
                              // Expanded(
                              //     child :  ListView.builder(
                              //       scrollDirection: Axis.vertical,
                              //       itemCount: viewModel.monthSchedule?.date?.length ?? 0,
                              //       itemBuilder: (context, index) {
                              //         String day = viewModel.monthSchedule!.date![index].day;
                              //         return Expanded(
                              //           child: Text("$day"),
                              //         );
                              //
                              //       },
                              //     )
                              // ),
                            ]
                        );
                    }
                ),
              )
          );
        }
    );
  }
}


Widget selectDateWidget(CostViewModel viewModel, BuildContext context){
  return Row(
    children: [
      Expanded(
        child: IconButton(
            onPressed: () async {
              int index = viewModel.dateIndex!;
              if(index > 0 ) {
                await viewModel.setDate(index-1);
                await viewModel.loadSchedule();
                await viewModel.getCost();
              }
            },
            icon: Icon(Icons.arrow_circle_left)),
      ),
      Expanded(
        child: TextButton(
          child: Text(
              '${viewModel.dateList![viewModel.dateIndex ?? 0].year}년 '
              '${viewModel.dateList![viewModel.dateIndex ?? 0].month}월',
              style: TextStyle(color: Colors.black)),
          onPressed: () => showDialog(
              CupertinoPicker(
                backgroundColor: Colors.white,
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                looping: false,
                // This sets the initial item.
                scrollController: FixedExtentScrollController(
                    initialItem:  viewModel.dateList!.length - viewModel.dateIndex! - 1
                ),
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItemIndex) {
                  viewModel.dateIndex = viewModel.dateList!.length - selectedItemIndex - 1;
                },
                children:
                List<Widget>.generate(viewModel.dateList!.length, (int index) {
                  int reversedIndex = viewModel.dateList!.length - index - 1;
                  return Center(
                      child: Text(
                          '${viewModel.dateList![reversedIndex].year}년'
                              ' ${viewModel.dateList![reversedIndex].month}월'));
                }),
              ),
              context,
              viewModel
          ),
        ),
      ),
      Expanded(
        child: IconButton(
            onPressed: () async {
              int index = viewModel.dateIndex ?? 0;
              if(index < viewModel.dateList!.length-1) {
                await viewModel.setDate(index+1);
                await viewModel.loadSchedule();
                await viewModel.getCost();
              }
            },

            icon: Icon(Icons.arrow_circle_right)),
      ),
    ],
  );
}

showDialog(Widget child, BuildContext context, CostViewModel viewModel) async {
  await showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 300,
      padding: const EdgeInsets.only(top: 3.0),
      // The bottom margin is provided to align the popup above the system
      // navigation bar.
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      // Provide a background color for the popup.
      color: CupertinoColors.systemBackground.resolveFrom(context),
      // Use a SafeArea widget to avoid system overlaps.
      child: SafeArea(
        top: true,
        child: child,
      ),
    ),
  );
  await viewModel.setDate(viewModel.dateIndex!);
  await viewModel.loadSchedule();
  await viewModel.getCost();
}


Widget box(String text,FontWeight font ){
  return Container(
    height: 40,
    decoration: BoxDecoration(
      border: Border.all(
        width : 1.0,
        color: Colors.grey,
      ),
    ),
    child : Center(
      child: Text(text, style: TextStyle(fontSize: 16,fontWeight: font)),
    ),
  );
}