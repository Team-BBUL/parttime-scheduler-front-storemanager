import 'account.dart';

class AccountRole{
  int? id;
  String? alias;
  int? level;
  int? cost;
  String? color;
  bool? salary;
  bool? valid;
  String? role;
  Account? account;

  AccountRole({this.id, this.alias, this.level, this.cost, this.color, this.salary, this.valid, this.account});
  AccountRole.newEmployee({
    required this.salary,
    required this.alias,
    this.role = 'EMPLOYEE',
});
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
    valid = json['valid'];
    role = json['role'];
  }
  AccountRole.fromJsonWithAccount(Map<String, dynamic> json){
    account = Account();
    account?.originAccountId = json['originAccountId'];
    account?.originPassword = json['originPassword'];
    id = json['id'];
    alias = json['alias'];
    level = json['level'];
    cost = json['cost'];
    color = json['color'];
    salary = json['salary'];
    valid = json['valid'];
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
    data['id'] = id;
    data['alias'] = alias;
    data['level'] = level;
    data['cost'] = cost;
    data['color'] = color;
    data['salary'] = salary;
    data['valid'] = valid;
    data['role'] = role;
    return data;
  }

  Map<String, dynamic> toJsonWithAccount(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = account!.originAccountId;
    data['password'] = account!.originPassword;
    data['id'] = id;
    data['alias'] = alias;
    data['level'] = level;
    data['cost'] = cost;
    data['color'] = color;
    data['salary'] = salary;
    data['valid'] = valid;
    data['role'] = role;
    return data;
  }

  Map<String, dynamic> toUpdateAccountJson() {
    Map<String, dynamic> data = <String, dynamic>{};

    data['alias'] = alias;
    data['level'] = level ?? 0;
    data['cost'] = cost ?? 0;
    data['color'] = color ?? '0x00000000';
    data['isSalary'] = salary;
    data['valid'] = valid;

    return data;
  }

  @override
  String toString() {
    return 'id: $id\n'
        'alias: $alias\n'
        'level: $level\n'
        'cost: $cost\n'
        'color: $color\n'
        'valid: $valid\n'
        'role: $role\n';
  }
}