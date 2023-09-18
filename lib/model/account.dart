class Account {
  String? originAccountId;
  String? originPassword;
  Account({this.originAccountId, this.originPassword});

  Account.fromJson(Map<String, dynamic> json) {
    originAccountId = json['accountId'];
    originPassword = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.originAccountId;
    data['password'] = this.originPassword;
    return data;
  }
}