class Anniversary{
  int? id;
  String? name;
  DateTime? date;

  Anniversary({this.id, this.name, this.date});

  Anniversary.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['date'] = this.date?.toIso8601String();
    return data;
  }
}