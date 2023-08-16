import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/view/notify.dart';

import '../view_model/notify_view_model.dart';



class NotifyPage extends StatelessWidget{
  const NotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotifyViewModel>(
        create: (_) => NotifyViewModel(),
        child: const NotifyScreen());
  }


}