import 'announcement_repository.dart';

class MockAnnouncementRepository implements AnnouncementRepository {

  @override
  Future<dynamic> fetchAnnouncement(String param1) async {
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
  Future<List<dynamic>> fetchAnnouncementList() async {
    // API 호출 및 응답 데이터 처리
    // 테스트용 데이터
    List<dynamic> testData = [
      {
        "id" : "1",
        "subject" : "subject1"
      },
      {
        "id": "2",
        "subject" : "subject2"
      },
      {
        "id": "3",
        "subject" : "subject3"
      }
    ];

    // 아이템 이름만 추출
    // final List announcementTitles = testData.map((item) => item['subject']).toList();
    return testData;
  }
}