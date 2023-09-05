import 'account.dart';

class AccountRole{
  int? id;
  String? alias;
  int? level;
  int? cost;
  String? color;
  bool? salary;
  bool? vaild;
  String? role;
  Account? account;

  AccountRole({this.id, this.alias, this.level, this.cost, this.color, this.salary, this.vaild, this.account});
  AccountRole.simple({
    required this.id,
    required this.alias,
    required this.color,
    required this.cost
  });

  AccountRole.fromJson(Map<String, dynamic> json){
    id = json['id'];
    alias = json['alias'];
    level = json['level'];
    cost = json['cost'];
    color = json['color'];
    salary = json['salary'];
    vaild = json['vaild'];
    role = json['role'];
  }

  factory AccountRole.fromSimpleJson(Map<String, dynamic> json) {
    return AccountRole(
        id: json['id'],
        alias: json['alias'],
        color: json['color'],
        cost: json['cost']
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['level'] = this.level;
    data['cost'] = this.cost;
    data['color'] = this.color;
    data['salary'] = this.salary;
    data['vaild'] = this.vaild;
    data['role'] = this.role;
    return data;
  }
}