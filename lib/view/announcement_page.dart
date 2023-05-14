import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/view/announcement.dart';
import 'package:sidam_storemanager/view/store_management.dart';
import 'package:sidam_storemanager/view_model/announcement_view_model.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel(),
        child: const AnnouncementScreen());
  }
}