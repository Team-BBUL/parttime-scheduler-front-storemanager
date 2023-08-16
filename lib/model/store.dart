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
  int? close;
  int? costPolicy;
  int? payday;
  int? weekStartDay;
  int? unworkableDaySelectDeadline;
  List<dynamic>? errors;

  Store({this.id, this.name, this.location, this.phone});
  Store.all({this.id, this.name, this.location, this.phone, this.open, this.close, this.costPolicy, this.payday, this.weekStartDay});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    phone = json['phone'];
    open = json['open'];
    close = json['close'];
    payday = json['payday'];
    weekStartDay = json['weekStartDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['open'] = this.open;
    data['close'] = this.close;
    data['payday'] = this.payday;
    data['weekStartDay'] = this.weekStartDay;
    return data;
  }

}