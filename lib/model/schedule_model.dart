import 'package:sidam_storemanager/model/account_role.dart';

class ScheduleList {
  final int id;
  final DateTime day;
  final List<Schedule> schedule;

  ScheduleList({
    required this.id,
    required this.day,
    required this.schedule
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "day": "${day.year}-${day.month}-${day.day}",
    "schedule": schedule.map<Map<String, dynamic>>(
            (value) => value.toJson()
    ).toList(),
  };
}

class Schedule {

  late int id;
  late DateTime day;
  late List<bool> time;
  late List<AccountRole> workers;

  Schedule({
    required this.id,
    required this.day,
    required this.time,
    required this.workers
  });

  Schedule.dummy(this.day, int time) {
    id = 0;
    workers = [];
    this.time = [];

    for (int i = 0; i < time; i++) {
      this.time.add(false);
    }
  }

  factory Schedule.fromJson(Map<String, dynamic> json, DateTime day) {
    return Schedule(
        id: json['id'],
        day: day,
        time: json['time'].map<bool>((value) {
          return value ? true : false;
        }).toList(),
        workers: json['workers'].map<AccountRole>((user) {
          return AccountRole.fromSimpleJson(user);
        }).toList()
    );
  }

  static Schedule fromSingleJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['id'],
        day: json['day'],
        time: json['time'].map<bool>((value) {
          return value ? true : false;
        }).toList(),
        workers: json['workers'].map<AccountRole>((user) {
          return AccountRole.fromSimpleJson(user);
        }).toList()
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "workers": workers.map<Map<String, dynamic>>((value) {
      return value.toJson();
    }).toList()
  };

  List<ViewSchedule> toViewSchedule() {
    List<ViewSchedule> result = [];
    int idx = 1;

    for (var worker in workers) {
      ViewSchedule viewSchedule = ViewSchedule(
          id: idx++,
          day: day,
          time: time,
          worker: worker
      );

      result.add(viewSchedule);
    }

    return result;
  }
}

class ViewSchedule {
  late int id;
  late DateTime day;
  late List<bool> time;
  late AccountRole worker;

  ViewSchedule({required this.id, required this.day, required this.time, required this.worker});
}