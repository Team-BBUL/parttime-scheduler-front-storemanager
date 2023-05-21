import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_storemanager/data/repository/announcement_repository_mock.dart';
import 'package:sidam_storemanager/view/announcement_list.dart';
import 'package:sidam_storemanager/view/store_management.dart';
import 'package:sidam_storemanager/view_model/announcement_list_view_model.dart';
import 'package:sidam_storemanager/view_model/store_management_view_model.dart';

class AnnouncementListPage extends StatelessWidget {
  const AnnouncementListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementListViewModel>(
        create: (_) => AnnouncementListViewModel(MockAnnouncementRepository()),
        child: const AnnouncementListScreen());
  }
}