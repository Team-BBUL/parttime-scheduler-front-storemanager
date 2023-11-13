import 'package:logger/logger.dart';

class DateUtility {

  // 이번 주차 시작일 찾기
  static DateTime findStartDay(DateTime base, int weekday) {

    if (base.weekday == weekday) { return DateTime(base.year, base.month, base.day); }

    if (base.weekday < weekday){
      return DateTime(base.year, base.month, base.day)
          .subtract(Duration(days: 7 - (weekday - base.weekday)));
    }
    else {
      return DateTime(base.year, base.month, base.day)
          .subtract(Duration(days: (base.weekday - weekday)));
    }
  }
}