class StoreList {
  List<Store>? data;

  StoreList({this.data});

  StoreList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Store>[];
      json['data'].forEach((v) {
        data!.add(new Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  StoreList filterStores(String keyword){
    print("keyword${keyword}");
    List filteredList = data!.where((store) => store.name!.contains(keyword)).toList();
    StoreList filteredStoreList = StoreList(data: filteredList as List<Store>);
    print(filteredStoreList.data!.length);
    return filteredStoreList;
  }
}

class Store {
  int? id;
  String? name;
  String? location;
  String? phone;
  int? open;
  int? closed;
  int? costPolicy;
  int? payday;
  int? startDayOfWeek;
  int? deadlineOfSubmit;
  List<dynamic>? errors;

  Store({this.id, this.name, this.location, this.phone});
  Store.all({this.id, this.name, this.location, this.phone, this.open, this.closed, this.costPolicy, this.payday, this.startDayOfWeek, this.deadlineOfSubmit});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    phone = json['phone'];
    open = json['open'];
    closed = json['closed'];
    payday = json['payday'];
    startDayOfWeek =  json['startDayOfWeek'];
    deadlineOfSubmit = json['deadlineOfSubmit'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['open'] = this.open;
    data['closed'] = this.closed;
    data['payday'] = this.payday;
    data['startDayOfWeek'] = this.startDayOfWeek;
    data['deadlineOfSubmit'] = this.deadlineOfSubmit;
    return data;
  }

  convertWeekdayToKorean(weekday) {
    if (weekday == 1) {
      return '월';
    } else if (weekday == 2) {
      return '화';
    } else if (weekday == 3) {
      return '수';
    } else if (weekday == 4) {
      return '목';
    } else if (weekday == 5) {
      return '금';
    } else if (weekday == 6) {
      return '토';
    } else if (weekday == 7) {
      return '일';
    }
  }
}