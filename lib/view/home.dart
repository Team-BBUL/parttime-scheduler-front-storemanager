import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/repository/store_repository.dart';
import 'package:sidam_storemanager/utils/app_future_builder.dart';
import 'package:sidam_storemanager/view/announcement_list.dart';
import 'package:sidam_storemanager/view/setting_page.dart';
import 'package:sidam_storemanager/view/store_list.dart';
import 'package:sidam_storemanager/view/store_management.dart';

import '../utils/sp_helper.dart';
import '../view_model/store_list_view_model.dart';
import '../view_model/store_management_view_model.dart';

class HomeScreen extends StatelessWidget {
  final SPHelper helper = SPHelper();

  @override
  Widget build(BuildContext context) {
    int? id = helper.getStoreId();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => SettingPage(),
                  ));
            },
            child: Consumer<StoreListViewModel>(
              builder: (context, viewModel, child) {
                return Text(
                    "${viewModel.accountRole?.alias ?? ''}",
                    style: TextStyle(color: Colors.black, fontSize: 16)
                );
              }
            )
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
                    "${storeName}",
                    style: TextStyle(color: Colors.black, fontSize: 16)
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
          builder: (context, builder) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AnnouncementListScreen()));
                    },
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 0,
                  child: TextButton(
                    child: const Text("매장정보설정"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const StoreManagementScreen())
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}
