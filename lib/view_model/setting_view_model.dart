import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sidam_storemanager/data/remote_data_source.dart';

class SettingViewModel extends ChangeNotifier{

  final Session _session = Session();
  int result = 0; // 0 요청 없음(non), 1 성공, 2 실패
  bool loading = false;
  String? error = "";

  SettingViewModel() {
    _session.init();
  }

  Future serverReset(int storeId, DateTime date) async {

    if (!loading) {
      loading = true;
      notifyListeners();

      DateFormat format = DateFormat("yyyy-MM-ddThh:mm:ss");

      Response res = await _session.delete("/api/schedule/$storeId?"
          "version=${format.format(DateTime.now())}&year=${date.year}&month=${date.month}&day=${date.day}");

      if (200 > res.statusCode || res.statusCode <= 300) {
        result = 2;
        error = jsonDecode(res.body)['body'];
      } else {
        result = 1;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        loading = false;
        notifyListeners();
      });
    }
  }
}