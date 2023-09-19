import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sidam_storemanager/view/announcement_view.dart';
import 'package:sidam_storemanager/view/enum/announcement_mode.dart';

import '../data/repository/announcement_repository.dart';
import '../model/announcement.dart';


class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementRepository _announcementRepository;
  Announcement? _announcement;
  Announcement? _newAnnouncement;
  AnnouncementMode? _mode;
  List<Announcement>? _announcementList;
  ScrollController? _scrollController;
  List<dynamic>? _images;
  List<dynamic>? _newImages;

  AnnouncementMode? get mode => _mode;
  List<Announcement>? get announcementList => _announcementList;
  get scrollController => _scrollController;
  get images => _images;
  get newImages => _newImages;
  Announcement? get announcement => _announcement;
  Announcement? get newAnnouncement => _newAnnouncement;

  AnnouncementViewModel(this._announcementRepository){
    log('---------------------------------AnnouncementViewModel constructor----------------------------------------------------------------------');
    int page = 1;
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
          _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        print('botton');
        // getAnnouncementList();
      }
      page++;
    });
  }

  Future<void> getAnnouncementList(int page) async {
    // await Future.delayed(Duration(seconds: 1));
    try {
      _announcementList = await _announcementRepository.fetchAnnouncementList(page);
      notifyListeners();
      log("announcementList = $_announcementList");
      // notifyListeners();
    } catch (e) {
      _announcementList = [];
      log('Error ${e}');
      throw e;
    }
  }

  Future<void> getAnnouncement(int announcementId) async {
    _announcement = null;
    try {
      _announcement = await _announcementRepository.fetchAnnouncement(announcementId);
      await _urlToImage();
      print("fetchAnnouncement success");

    } catch (e) {
      //클릭 시 글을 찾을 수 없음(특정 코드로 와야됨) -> 알림 -> 확인 -> pop -> list에서 삭제 -> notify
      log('Error ${e}');
    }
  }

  Future _urlToImage() async{
    _images = [];
    if(_announcement!.getPhoto != null){
      int length = _announcement!.getPhoto!.length;
      print("_urlToImage : $length");
      for(int i = 0; i < length; i++ ){
        _images!.add( await _announcementRepository.getImage(
            _announcement!.getPhoto![i].downloadUrl ?? '',
            _announcement!.getPhoto![i].fileName ?? ''));
      }
    }
  }

  Future createAnnouncement() async {
    try{
      Announcement fragment = await _announcementRepository.postAnnouncement(_newAnnouncement!, _newImages!);
      _newAnnouncement!.id = fragment.id;
      _newAnnouncement!.timeStamp = fragment.timeStamp;
      _announcementList!.insert(0, _newAnnouncement!);
      print("fragment.id = ${fragment.id}");
      notifyListeners();
    }catch(e){

    }
  }

  Future updateAnnouncement() async {
    try {
      await _announcementRepository.updateAnnouncement(_newAnnouncement!);
      _announcement!.replaceObject(_newAnnouncement!);
      _replaceAnnouncementListWithObject();
      notifyListeners();
    } catch (e) {
      // 오류 처리
      print(e);
    }
  }

  Future deleteAnnouncement(int? announcementId) async{
    try{
      await _announcementRepository.deleteAnnouncement(announcementId!);
      _announcementList!.removeWhere((Announcement announcement) => announcement.id == announcementId);
      print(_announcementList!.length);
      notifyListeners();
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      File file = File(pickedImage.path);
      _newImages?.add(file);
      notifyListeners();
    }
  }

  void createEditForm(){
    final Map<String, dynamic> jsonData = announcement!.toJson();
    _newAnnouncement = Announcement.fromJson(jsonData);
    _newImages = List.from(_images!);
    // images = List.from(announcement!.memoryImage!);
    _mode = AnnouncementMode.EDIT;
  }

  //목록 조회(api) -> 글 조회(api) -> pop(x)
  //목록 조회(api) -> 글 조회(api) -> 작성/수정 완료(api) -> pop 글 조회(x) -> pop 목록 조회(x)

  void createNewForm(){
    _newAnnouncement = Announcement(
        id: null,
        subject: '',
        content: '',
        photo: [],
        getPhoto: [],
        timeStamp: null);
    _newImages = [];
    _newAnnouncement!.memoryImage = [];
    _mode = AnnouncementMode.CREATE;
  }

  updateSubject(String text) {
    _newAnnouncement?.subject = text;
  }

  updateBody(String text) {
    _newAnnouncement?.content = text;
  }

  void _replaceAnnouncementListWithObject(){
    for(int i = 0; i < announcementList!.length; i++){
      if(announcementList![i].id == _newAnnouncement?.id){
        announcementList![i].subject = _newAnnouncement?.subject;
        announcementList![i].content = _newAnnouncement?.content;
        break;
      }
    }
  }

  void setMode(AnnouncementMode mode){
    _mode = mode;
    notifyListeners();
  }
}
