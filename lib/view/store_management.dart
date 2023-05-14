import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/model/appColor.dart';
import 'package:sidam_storemanager/view/cost_policy.dart';
import 'package:sidam_storemanager/view/employee_details.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

class StoreManagementScreen extends StatelessWidget{
  BoxDecoration boxDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 2, color: AppColor().mainColor),
    );
  }
  EdgeInsets marginSpace(){
    return const EdgeInsets.symmetric(vertical: 5,horizontal: 10);
  }
  Widget boxText(String param) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(param, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
  const StoreManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Store Management Screen'),
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
        body: Consumer<StoreManagementViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: marginSpace(),
                    decoration: boxDecoration(),
                      child: boxText(viewModel.storeManagement.location)
                  ),
                  Container(
                      margin: marginSpace(),
                      decoration: boxDecoration(),
                      child: boxText(viewModel.storeManagement.phoneNum)
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      margin: marginSpace(),
                      decoration: boxDecoration(),
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                                child: Text('개점 ${viewModel.storeManagement
                                    .open}', style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                              )
                          ),
                          Expanded(
                              child: Center(
                                child: Text('매점  ${viewModel.storeManagement
                                    .close}', style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                              )
                          ),
                        ],
                      )
                  ),
                  Expanded(
                    flex: 0,
                      child: Container(
                        margin: marginSpace(),
                        decoration: boxDecoration(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Center(
                                      child: Text(
                                          viewModel.storeManagement.costPolicy,
                                          style: const TextStyle(fontSize: 16)),
                                    )
                                ),
                                const Expanded(
                                    child: Center(
                                        child: Icon(Icons.radio_button_checked)
                                    )
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    Navigator.push(
                                        context, MaterialPageRoute<void>(
                                        builder: (
                                            BuildContext context) => CostPolicyScreen()
                                    ));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                  ),
                  Expanded(
                    flex: 0,
                      child: Container(
                          margin: marginSpace(),
                          decoration: boxDecoration(),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                  child: Column(
                                    children: viewModel.userRole
                                      .map((e) => Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                e.role, style: const TextStyle(fontSize: 16)),
                                          ),
                                          Expanded(
                                            child: Text(
                                                e.name, style: const TextStyle(fontSize: 16)),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                Navigator.push(
                                                    context, MaterialPageRoute<void>(
                                                    builder: (
                                                        BuildContext context) => EmployeeDetailScreen(userRole : e)
                                                ));
                                              },
                                            ),
                                          )
                                        ],
                                      )).toList(),
                                  )
                              ),
                              const Expanded(
                                flex: 1,
                                  child: Text('')
                              )
                            ],
                          )
                      )
                  )
                  ,
                  Container(
                      margin: marginSpace(),
                      decoration: boxDecoration(),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                '매월 ' + viewModel.storeManagement.payday,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      )
                  ),
                ],
              );
            }
        )
    );
  }


}