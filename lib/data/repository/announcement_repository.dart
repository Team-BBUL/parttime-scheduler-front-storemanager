abstract class AnnouncementRepository {
  Future<dynamic> fetchAnnouncement(String announcementId);
  Future<List<dynamic>> fetchAnnouncementList();
}