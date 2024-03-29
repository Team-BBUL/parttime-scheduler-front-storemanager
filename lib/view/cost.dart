import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_color.dart';
import 'package:sidam_storemanager/utils/app_future_builder.dart';
import 'package:sidam_storemanager/utils/custom_expansion_tile.dart';
import 'package:sidam_storemanager/view_model/cost_view_model.dart';

import '../model/employee_cost.dart';

class CostScreen extends StatelessWidget {
  const CostScreen({super.key});

  List<Widget> generateRowOfMonths(from, to, CostViewModel viewModel) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(viewModel.pickerYear, i, 1);
      final selectedColor = dateTime.isAtSameMomentAs(viewModel.selectedMonth)
          ? AppColor().mainColor
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(selectedColor),
            onPressed: () {
              viewModel.changeMonth(dateTime);
            },
            style: TextButton.styleFrom(
              backgroundColor: selectedColor,
              side: BorderSide(
                color: selectedColor,
                width: 1,
              ),
              shape: CircleBorder(),
            ),
            child: Text(
              '${DateFormat('M').format(dateTime)}월',style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths(CostViewModel viewModel) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6, viewModel),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12, viewModel),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    var cost = NumberFormat('###,###,###,###,###');

    final mainContext = context;
    final viewModel = Provider.of<CostViewModel>(context,listen: false );
    return AppFutureBuilder(
        future: viewModel.loadData(),
        builder: (builder, context){
          return Scaffold(
              body: SafeArea(
                child : Consumer<CostViewModel>(
                    builder:(context, viewModel,child){
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              monthPicker(viewModel),
                                Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                              child: Row(
                                                children:  [
                                                  Expanded(
                                                      child:
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
                                                      child: Text('${cost.format(viewModel.totalPay)}원',
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
                                                      "${viewModel.selectedMonth!.subtract(const Duration(days: 30)).month}월 달 보다 "
                                                          "${(viewModel.totalPay - viewModel.prevMonthTotalPay >= 0) ?
                                                      "${cost.format(viewModel.totalPay - viewModel.prevMonthTotalPay)}원 증가"
                                                          :
                                                      "${cost.format(-(viewModel.totalPay - viewModel.prevMonthTotalPay))}원 감소"}"
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
                                          SizedBox(
                                            height: 500,
                                            child:  Row(
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child:Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(20.0),
                                                        bottomRight: Radius.circular(20.0),
                                                      ),
                                                      // border: Border.all(color: Colors.grey, width: 2),
                                                    ),

                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Expanded(child: Center(child : Text("근무자명", ))),
                                                        Expanded(child: Center(child : Text("시급/월급",))),
                                                        Expanded(child: Center(child : Text("근무시간",))),

                                                        Expanded(child: Center(child : Text("주휴수당",))),

                                                        Expanded(child: Center(child : Text("인센티브",))),

                                                        Expanded(child: Center(child : Text("보너스데이\n지급액",))),

                                                        Expanded(child: Center(child : Text("총 월급여",))),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 8,
                                                    child:
                                                    viewModel.employeesCost!.isEmpty ?
                                                    Center(
                                                      child: Text("근무 스케쥴이 없습니다."),
                                                    )
                                                        :
                                                    ListView.builder(
                                                      physics: ClampingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: viewModel.employeesCost!.length,
                                                      itemBuilder: (context, index) {
                                                        EmployeeCost employeeCost = viewModel.getEmployeeCost(index);
                                                        return Card(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children : [
                                                                  Expanded(
                                                                      child: Center(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                                          child: Text(employeeCost.alias,
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontSize: 16),),
                                                                      ))
                                                                  ),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text('${cost.format(employeeCost.hourlyPay)}원',
                                                                        style: TextStyle(fontSize: 16),),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text('${employeeCost.totalWorkTime}시간',
                                                                        style: TextStyle(fontSize: 16),),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text('${cost.format(employeeCost.holidayPay)}원',
                                                                        style: TextStyle(fontSize: 16),),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text('${cost.format(employeeCost.monthIncentive)}원',
                                                                        style: TextStyle(fontSize: 16),),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Text('${cost.format(employeeCost.bonusDayPay)}원',
                                                                        style: TextStyle(fontSize: 16),),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                      Center(
                                                                        child: Text('${cost.format(employeeCost.monthPay)}원',
                                                                          style: TextStyle(fontSize: 16),),
                                                                      ),

                                                                  )
                                                                ]
                                                            )
                                                        );
                                                      },
                                                    )

                                                )
                                              ],
                                            )
                                          )
                                        ],
                                      ),
                                    )
                                )
                            ]
                        );
                    }
                ),
              )
          );
        }
    );
  }

  Widget monthPicker(CostViewModel viewModel) {
    return MyExpansionTile(
      onExpansionChanged: (value) {
        viewModel.setCustomTileExpanded(value);
      },
      textColor: Colors.black,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              viewModel.serPickerYear(viewModel.pickerYear - 1);
            },
            icon: const Icon(Icons.navigate_before_rounded, color: Colors.black,),
          ),
          Expanded(
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 30,height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        viewModel.pickerYear.toString() + "년 "+ viewModel.selectedMonth.month.toString() + "월",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    viewModel.customTileExpanded ?
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(Icons.arrow_drop_up,size: 30, color: Colors.black,),
                    )
                        :
                    const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.arrow_drop_down, size: 30, color: Colors.black,)
                    )
                  ],
                )
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.serPickerYear(viewModel.pickerYear + 1);
            },
            icon: const Icon(Icons.navigate_next_rounded, color: Colors.black,),
          ),
        ],
      ),
      children: generateMonths(viewModel),
    );
  }


}
