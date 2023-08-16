import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/utils/app_future_builder.dart';
import 'package:sidam_storemanager/view/announcement_list.dart';
import 'package:sidam_storemanager/view/setting_page.dart';
import 'package:sidam_storemanager/view/store_list.dart';
import 'package:sidam_storemanager/view/store_management.dart';

import '../utils/sp_helper.dart';

class HomeScreen extends StatelessWidget{
  final SPHelper helper = SPHelper();

  @override
  Widget build(BuildContext context) {
    int? id = helper.getStoreId();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading:  TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => SettingPage(),
              ));
            },
            child: Text('${helper.getAlias()}', style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        title: TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => StoreListPage(),
              ));
            },
            child: Text("${helper.getStoreName()}", style: TextStyle(color: Colors.black, fontSize: 16))
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => SettingPage(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],

      ),
      body: AppFutureBuilder(
        future: StoreRepositoryImpl().fetchStore(id),
        builder: (context, builder){
          return Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) => const AnnouncementListScreen()
                    ));
                  },
                ),
              ),
              Positioned(
                top: 30,
                right: 0,
                child: TextButton(
                  child: const Text("매장정보설정"),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) => const StoreManagementScreen()
                    ));
                  },
                ),
              ),
            ],
          );
        },
      )
    );
  }
}