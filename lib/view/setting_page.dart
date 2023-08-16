import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/view/setting.dart';
import 'package:sidam_storemanager/view_model/setting_view_model.dart';

class SettingPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingViewModel>(
        create: (_) => SettingViewModel(),
        child: SettingScreen());
  }

}