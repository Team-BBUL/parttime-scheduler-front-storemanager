import 'package:flutter/material.dart';
import 'package:sidam_storemanager/data/model/announcement.dart';
import 'package:sidam_storemanager/data/repository/announcement_repository_mock.dart';

import '../data/repository/announcement_repository.dart';

class AnnouncementListViewModel extends ChangeNotifier{

  AnnouncementRepository announcementRepository;
  List announcementList =[];

  AnnouncementListViewModel(this.announcementRepository){
    fetchList();
  }

  Future<void> fetchList() async {
    try {
      final result = await announcementRepository.fetchAnnouncementList();
      announcementList = result;
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
    }
  }
}
