class MonthSchedule {
  List<dynamic>? date;
  String? timeStamp;

  MonthSchedule({this.date, this.timeStamp});

  MonthSchedule.fromJson(Map<String, dynamic> json) {
    if (json['date'] != null) {
      date = <Date>[];
      json['date'].forEach((v) {
        if(v != null){
          date!.add(new Date.fromJson(v));
        }
      });
    }
    timeStamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) {
      data['date'] = this.date!.map((v) => v.toJson()).toList();
    }
    data['time_stamp'] = this.timeStamp;
    return data;
  }

}
class Date {
  int? id;
  String? day;
  List<Schedule>? schedule;

  Date({this.id, this.day, this.schedule});

  Date.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    if (json['schedule'] != null) {
      schedule = <Schedule>[];
      json['schedule'].forEach((v) {
        schedule!.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    if (this.schedule != null) {
      data['schedule'] = this.schedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Schedule {
  int? id;
  DateTime? day;
  List<bool>? time;
  List<Workers>? workers;

  Schedule({this.id, this.time, this.workers, this.day});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'].cast<bool>();
    if (json['workers'] != null) {
      workers = <Workers>[];
      json['workers'].forEach((v) {
        workers!.add(Workers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time;
    if (workers != null) {
      data['workers'] = workers!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Workers {
  int? id;
  String? name;
  String? color;
  int? cost;

  Workers({this.id, this.name, this.color, this.cost});

  Workers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['cost'] = this.cost;
    return data;
  }
}