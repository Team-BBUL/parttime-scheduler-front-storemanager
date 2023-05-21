import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/announcement.dart';
import '../data/repository/announcement_repository.dart';
import '../data/repository/announcement_repository_mock.dart';

class AnnouncementViewModel extends ChangeNotifier {

  AnnouncementRepository announcementRepository;
  List<String> imagePaths = [];
  bool isEditMode = false;
  Map<String, dynamic> announcement = {};

  AnnouncementViewModel(this.announcementRepository,String announcementId) {
    fetchAnnouncement(announcementId);
  }
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imagePaths.add(pickedImage.path);
      notifyListeners();
    }
  }
  Future<void> fetchAnnouncement(String announcementId) async {
    try {
      final result = await announcementRepository.fetchAnnouncement(announcementId);
      announcement = result;
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
    }
  }

  void toggleEditMode() {
    isEditMode = !isEditMode;
    notifyListeners();
  }

  void updateText(String newText) {
    announcement['content'] = newText;
    notifyListeners();
  }


  
}