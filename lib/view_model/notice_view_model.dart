import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'package:sidam_storemanager/data/remote_data_source.dart';
import 'package:sidam_storemanager/model/notice_model.dart';
import 'package:sidam_storemanager/utils/sp_helper.dart';

class NoticeViewModel extends ChangeNotifier {

  final _logger = Logger();

  late final Session _session = Session();
  Notice _mainNotice = Notice(title: '공지사항이 없습니다', timeStamp: DateTime.now().toIso8601String(), id: 0, read: true);
  Notice get lastNotice => _mainNotice;
  final SPHelper _helper = SPHelper();

  NoticeViewModel() {
    _session.init();
    _helper.init();
    getTitle();
  }

  Future<void> getTitle() async {
    _mainNotice = await _loadMainNotice();
    notifyListeners();
  }

  Future<void> reload() async {
    _mainNotice = await _loadMainNotice();
  }

  Future<Notice> _loadMainNotice() async {

    var res = await _session.get("/api/notice/${_helper.getStoreId()}/view/list?last=0&cnt=1&role=${_session.roleId}");

    var data = jsonDecode(res.body);

    if (res.statusCode == 200 && data['data'].isNotEmpty) {
      return Notice.fromJson(data['data'][0]);
    } else {
      _logger.e('공지사항 불러오기 오류: ${data['message'] ?? '데이터가 없습니다.'}');
      return Notice(title: '공지사항이 없습니다', timeStamp: '2023-01-01', id: 0, read: true);
    }
  }
}