import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data/repository/announcement_repository_mock.dart';
import '../view_model/announcement_view_model.dart';
import 'announcement_detail.dart';

class AnnouncementDetailPage extends StatelessWidget {
  const AnnouncementDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String announcementId = ModalRoute.of(context)!.settings.arguments as String;
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel(MockAnnouncementRepository(),announcementId),
        child: const AnnouncementDetailScreen());
  }
}