class Store{
  String id;
  String location;
  String name;
  String phone;
  String open;
  String close;
  String costPolicy ;
  String payday;
  Store({ required this.id,required this.location, required this.name, required this.phone, required this.open, required this.close,
    required this.costPolicy, required this.payday});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id : json['id'],
      location: json['location'],
      name: json['name'],
      phone: json['phone'],
      open: json['open'],
      close: json['close'],
      costPolicy: json['costPolicy'],
      payday: json['payday'],
    );
  }
}
