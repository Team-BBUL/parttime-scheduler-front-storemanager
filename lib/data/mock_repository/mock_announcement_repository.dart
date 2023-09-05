import 'dart:developer';

import '../../model/announcement.dart';
import '../repository/announcement_repository.dart';

class FixedAnnouncementRepositoryStub implements AnnouncementRepository {

  @override
  Future<Announcement> fetchAnnouncement(int param1) async {
    log('MockAnnouncementRepository.getAnnouncement ${DateTime.now()}}');
    dynamic mockData = {
      'id': param1,
      'subject': 'subject1',
      'body' : 'content1',
      'photo':'photo',
      'timestamp':'timestamp'
    };
    return mockData;
  }

  @override
  Future<List<Announcement>> fetchAnnouncementList(int page) async {
    log('MockAnnouncementRepository.getAnnouncementList ${DateTime.now()}}');
    Map<String, dynamic> testData = {
      "data":[
        {
          "id" : "1",
          'subject': 'subject1',
          'timestamp':'timestamp'
        },
        {
          "id": "2",
          'subject': 'subject2',
          'timestamp':'timestamp'
        },
        {
          "id": "3",
          'subject': 'subject3',
          'timestamp':'timestamp'
        }
      ]
    };
    return (testData['data'] as List<dynamic>?)
        ?.map((dynamic json) => Announcement.fromJson(json))
        .toList() ?? [];
  }


  @override
  Future<dynamic> updateAnnouncement(Announcement announcement) async{
    print('MockAnnouncementRepository.updateAnnouncement $announcement');
    return announcement;
    throw UnimplementedError();
  }

  @override
  Future deleteAnnouncement(int announcementId) async{
    throw UnimplementedError();
  }

  @override
  Future getImage(String url, String fileName) {
    throw UnimplementedError();
  }

  @override
  Future postAnnouncement(Announcement announcement, List<dynamic> images) {
    throw UnimplementedError();
  }
}