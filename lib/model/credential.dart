class CredentialModel {
  String username;
  String token;
  String ur;
  String email;
  String name;
  String dept;
  CredentialModel(
      {this.username, this.token, this.ur, this.email, this.name, this.dept});

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    return new CredentialModel(
        username: json['username'],
        token: json['token'],
        ur: json['ur'],
        email: json['email'],
        name: json['name'],
        dept: json['dept']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["token"] = token;
    map["ur"] = ur;
    map["name"] = name;
    map["email"] = email;
    map["dept"] = dept;
    return map;
  }

//  Map toMap(){
//    var map = new Map<String, dynamic>();
//    map["username"] = username;
//    map["token"] = token;
//    map["ur"] = ur;
//    return map;
//  }
  Map<String, dynamic> toJson() =>
      {'username': username, 'token': token, 'ur': ur, 'email':email, 'name':name, 'dept':dept};
}
