class Account {
  String email;
  String uid;
  String std;
  String name;

  Account({this.email, this.uid, this.name, this.std});

  Account.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uid = json['uid'];
    name = json['class'];
    std = json['std'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = email;
    data['uid'] = uid;
    data['std'] = std;
    data['name'] = name;
    return data;
  }
}
