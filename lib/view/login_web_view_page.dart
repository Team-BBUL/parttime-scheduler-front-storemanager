import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/repository/user_repository.dart';

import '../view_model/login_view_model.dart';
import 'login_web_view.dart';


class LoginWebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(UserRepositoryImpl()),
      child: LoginWebView(),
    );
  }
}