class CredentialModel {
  String username;
  String token;
  String role;
  String email;
  String name;
  CredentialModel(
      {this.username, this.token, this.role, this.email, this.name});

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    return new CredentialModel(
        username: json['username'],
        token: json['token'],
        role: json['role'],
        email: json['email'],
        name: json['name']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["token"] = token;
    map["role"] = role;
    map["name"] = name;
    map["email"] = email;
    return map;
  }

//  Map toMap(){
//    var map = new Map<String, dynamic>();
//    map["username"] = username;
//    map["token"] = token;
//    map["role"] = role;
//    return map;
//  }
  Map<String, dynamic> toJson() =>
      {'username': username, 'token': token, 'role': role, 'email':email, 'name':name};
}
