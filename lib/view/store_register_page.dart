import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/repository/store_repository_mock.dart';
import 'package:sidam_storemanager/view/store_register.dart';

import '../view_model/store_register_view_model.dart';

class StoreRegisterPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreRegisterViewModel>(
        create: (_) => StoreRegisterViewModel(),
        child: StoreRegisterScreen());
  }
}