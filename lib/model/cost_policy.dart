class CostPolicy{
  int? id;
  double? multiplyCost;
  String? description;
  DateTime? date;

  CostPolicy({ this.id, this.multiplyCost, this.description, this.date});

  CostPolicy.fromJson(Map<String, dynamic> json){
    id = json['id'];
    multiplyCost = json['multiplyCost'];
    description = json['description'];
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cost'] = this.multiplyCost;
    data['description'] = this.description;
    data['date'] = this.date?.toIso8601String();
    return data;
  }
}