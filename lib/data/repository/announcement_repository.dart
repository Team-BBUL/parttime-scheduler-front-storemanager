import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';


import '../../model/announcement.dart';
import 'package:http/http.dart' as http;
import '../../utils/sp_helper.dart';

abstract class AnnouncementRepository {
  Future<Announcement> fetchAnnouncement(int announcementId);
  Future<List<Announcement>> fetchAnnouncementList(int page);
  Future<dynamic> postAnnouncement(Announcement announcement, List<dynamic> images);
  Future<dynamic> updateAnnouncement(Announcement announcement);
  Future deleteAnnouncement(int announcementId);
  Future getImage(String url, String fileName);
}

class AnnouncementRepositoryImpl implements AnnouncementRepository{

  String noticeApi = 'http://10.0.2.2:8088/api/notice/';
  SPHelper helper = SPHelper();

  @override
  Future<Announcement> fetchAnnouncement(int announcementId) async {
    final String apiUrl = '$noticeApi${helper.getStoreId()}'
        '/view/detail?id=$announcementId';
    log("fetchAnnouncement $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      return Announcement.fromJson(decodedData['data']);
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future<List<Announcement>> fetchAnnouncementList(int page) async {
    SPHelper helper2 = SPHelper();
    final String apiUrl = '$noticeApi${helper.getStoreId()}/view/list?last=0&cnt=10000';
    log("fetchAnnouncementList $apiUrl");
    log("fetchAnnouncementHelperHash: ${helper.hashCode}");
    log("fetchAnnouncementHelperJwt: ${helper2.getJWT()}");
    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      List<Announcement> announcementList = [];
      for (var item in decodedData['data']) {
        announcementList.add(Announcement.fromJson(item));
      }
      log("${announcementList.length}");
      log('NoticeList get successfully.');
      return announcementList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future postAnnouncement(Announcement announcement, List<dynamic> images) async {
    final String apiUrl = '$noticeApi${helper.getStoreId()}';
    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};
    log("postAnnouncement $apiUrl");
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl),
    );
    int length = images.length ?? 0;
    log("length : $length");
    for(int i =0; i < length ; i++){
      var image = images[i];
      log("image : $image");
      var stream = http.ByteStream(image.openRead());
      log("stream : $stream");
      var length = await image.length();
      var multipartFile = http.MultipartFile('images', stream, length,
      filename: 'image$i.jpg');

      request.files.add(multipartFile);
      }

    request.headers.addAll(headers);
    request.fields['subject'] = announcement.subject!;
    request.fields['content'] = announcement.content!;

    log("postAnnouncementRequest : $request");
    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      log(response.body);
      return Announcement.fromJson(json.decode(response.body));
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      log('failed : ${response.body}');

      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future updateAnnouncement(Announcement announcement) async {
    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};
    final String apiUrl = '$noticeApi${helper.getStoreId()}'
        '/view/detail';
    log("fetchAnnouncement $apiUrl");
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(announcement.toJson()),
    );
    if (response.statusCode == 200) {
      log(response.body);
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      log('failed : ${response.body}');

      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future deleteAnnouncement(int announcementId) async{
    final String apiUrl = '$noticeApi${helper.getStoreId()}'
        '/view/detail?id=$announcementId';
    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};
    log("fetchAnnouncement $apiUrl");
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log(response.body);
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future getImage(String url, String fileName) async {
    final String apiUrl = "http://10.0.2.2:8088$url?filename=$fileName";
    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};
    Uint8List imageBytes;
    log("getImage $apiUrl");
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
      return imageBytes;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      log('failed : ${response.body}, status code : ${response.statusCode}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }


}