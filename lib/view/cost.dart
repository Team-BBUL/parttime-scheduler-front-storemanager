import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/view_model/cost_view_model.dart';


class CostScreen extends StatefulWidget {
  const CostScreen({super.key});

  @override
  _CostScreenState createState() => _CostScreenState();
}
class _CostScreenState extends State<CostScreen> with SingleTickerProviderStateMixin{
  late String selectedText;
  @override
  void initState() {
    selectedText = '2023년 3월';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost Screen'),
      ),
      body: Consumer<CostViewModel>(
        builder:(context, viewModel,child){
          return SingleChildScrollView(
            child : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: selectDateWidget(),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Row(
                      children: const [
                        Expanded(
                            child:
                            Text("이번 달 총 인건비")
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
                Container(
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text('10,000,000원', style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(
                              child: Text("")
                          ),
                        ),
                        Expanded(
                          child: Text("2월 달 보다 20,000원 증가"),
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
                            Text("특정 근무자 별 월급")
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
                Container(
                    child:  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.userRole.length,
                      itemBuilder: (context, index){
                      final item = viewModel.userRole[index];
                      final isExpanded = viewModel.isExpandedList[index];
                        return Column(
                          children: [
                            Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:Row(
                                          children: [
                                            IconButton(
                                              icon:Icon(Icons.arrow_drop_down),
                                              onPressed: () {viewModel.toggleItemSelection(index);},
                                            ),
                                            Text("${item.level} ${item.alias}"),
                                          ],
                                        )
                                    ),

                                  ],
                                )
                            ),
                            AnimatedContainer(
                              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              duration: Duration(milliseconds: 500),
                               height: isExpanded ? (viewModel.isExpandedList.length)*27.0 : 0.0,
                              curve: Curves.easeInOut,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Row(
                                        children: const [
                                          Expanded(
                                            child: Center(
                                              child: Text('2,200,000원', style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Expanded(
                                      child: Row(
                                        children: const [
                                          Expanded(
                                            child: Center(
                                                child: Text("")
                                            ),
                                          ),
                                          Expanded(
                                            child: Text("2월 달 보다 원 변동 없음"),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                  )
                ),
              ]
            )
          );
        }
      ),
    );
  }

  Widget selectDateWidget() {
    return Row(
      children: [
        Expanded(
            child: Icon(Icons.arrow_circle_left)
        ),
        Expanded(
          child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select Text'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: const Text('2023년 2월'),
                              onTap: () {
                                setState(() {
                                  selectedText = '2023년 2월';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(8.0)),
                            GestureDetector(
                              child: const Text('2023년 3월'),
                              onTap: () {
                                setState(() {
                                  selectedText = '2023년 3월';
                                });
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
              child: Center(
                child: Text(
                  selectedText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
          ),
        ),
        Expanded(
            child: Icon(Icons.arrow_circle_right)
        )
      ],
    );
  }




}