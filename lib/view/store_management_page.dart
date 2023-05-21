import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/repository/store_repository_mock.dart';
import 'package:sidam_storemanager/data/repository/user_repository_mock.dart';
import 'package:sidam_storemanager/view/store_management.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

class StoreManagementPage extends StatelessWidget {
  const StoreManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreManagementViewModel>(
        create: (_) => StoreManagementViewModel(MockStoreRepository(),MockUserRepository()),
        child: const StoreManagementScreen());
  }
}