import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/utils/app_color.dart';
import 'package:sidam_storemanager/utils/app_future_builder.dart';
import 'package:sidam_storemanager/view/announcement_list.dart';
import 'package:sidam_storemanager/view/setting_page.dart';
import 'package:sidam_storemanager/view/store_list.dart';
import 'package:sidam_storemanager/view/store_management.dart';
import 'package:sidam_storemanager/view_model/notice_view_model.dart';

import './widget/schedule_viewer.dart';
import '../utils/sp_helper.dart';
import '../view_model/store_list_view_model.dart';
import '../view_model/store_management_view_model.dart';

class HomeScreen extends StatelessWidget {
  final SPHelper helper = SPHelper();
  final AppColor color = AppColor();

  @override
  Widget build(BuildContext context) {
    int? id = helper.getStoreId();
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Consumer<StoreListViewModel>(
              builder: (context, viewModel, child) {
                return Center(child: Text(
                    viewModel.accountRole?.alias ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 16)
                ));
              }
            ),
          title: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => StoreListScreen(),
                  ));
            },
            child: Consumer2<StoreManagementViewModel,StoreListViewModel>(
              builder: (context, manageViewModel, listViewModel, child) {
                String storeName ='';
                if (manageViewModel.store != null && listViewModel.store != null) {
                  if (manageViewModel.updatedAt.isAfter(listViewModel.updatedAt)) {
                    storeName = manageViewModel.store!.name!;
                  } else {
                    storeName = listViewModel.store!.name!;
                  }
                } else if (manageViewModel.store != null) {
                  storeName = manageViewModel.store!.name!;
                } else if (listViewModel.store != null) {
                  storeName = listViewModel.store!.name!;
                }
                return Text(
                    storeName,
                    style: const TextStyle(color: Colors.black, fontSize: 16)
                );
              }
            )
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SettingPage(),
                    ));
              },
            ),
          ],
        ),
        body: AppFutureBuilder(
          future: StoreRepositoryImpl().fetchStore(id),
          builder: (context, builder) {
            return Column(
              children: [
                Container(
                  color: color.mainColor,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<NoticeViewModel>(builder: (context, state, child){
                        return Text('    ${state.lastNotice.title}');
                      }),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute<void>(builder:
                              (BuildContext context) => const AnnouncementListScreen())
                          );},
                      ),
                  ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text("매장정보설정"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) => const StoreManagementScreen()));
                      },),
                ),
                mainTimeTable(deviceHeight),
              ],
            );
          },
        )
    );
  }

  Widget mainTimeTable(double deviceHeight) {

    return SizedBox(
        width: double.infinity,
        height: deviceHeight - 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 여기에 시간표 위젯
            ScheduleViewer(),
          ],
        )
    );
  }
}
