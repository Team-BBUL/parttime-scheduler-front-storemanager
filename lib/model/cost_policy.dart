class CostPolicy{
  int? id;
  double? multiplyCost;
  String? description;
  int? day;

  CostPolicy({ this.id, this.multiplyCost, this.description, this.day});

  CostPolicy.fromJson(Map<String, dynamic> json){
    id = json['id'];
    multiplyCost = json['multiplyCost'];
    description = json['description'];
    day = json['day'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['multiplyCost'] = this.multiplyCost;
    data['description'] = this.description;
    data['day'] = this.day;
    return data;
  }
}