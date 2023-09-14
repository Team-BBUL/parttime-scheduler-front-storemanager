class AccountData {
  String accountId;
  String password;
  String role;

  AccountData({required this.accountId, required this.password, required this.role});

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
        accountId: json['accountId'],
        password: json['password'],
        role: json['role']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['password'] = password;
    data['role'] = role;
    return data;
  }
}