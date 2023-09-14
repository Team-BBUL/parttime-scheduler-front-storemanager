import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/utils/app_color.dart';
import 'package:sidam_storemanager/view/announcement_list.dart';
import 'package:sidam_storemanager/view/setting_page.dart';
import 'package:sidam_storemanager/view/store_management.dart';
import 'package:sidam_storemanager/view_model/notice_view_model.dart';

import './widget/schedule_viewer.dart';
import '../utils/sp_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  final SPHelper helper = SPHelper();
  final AppColor color = AppColor();
  final Logger _logger = Logger();

  String _storeName = '매장';
  String _userAlias = '이름';

  void loadSPProvider() async {

    await helper.init();

    setState(() {
      _storeName = helper.getStoreName() ?? '매장';
      _userAlias = helper.getAlias() ?? '이름';
    });
  }

  @override
  Widget build(BuildContext context) {
    loadSPProvider();

    int? id = helper.getStoreId();
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Center(child: Text(_userAlias,
              style: const TextStyle(color: Colors.black, fontSize: 16)
          )),
          title: Text(_storeName,
              style: const TextStyle(color: Colors.black, fontSize: 16)
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
        body: SafeArea(
          child: Column(
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
            )
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
