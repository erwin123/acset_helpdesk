class CredentialModel {
  String username;
  String token;
  String role;

  CredentialModel({this.username, this.token, this.role});

  factory CredentialModel.fromJson(Map<String, dynamic> json){
    return new CredentialModel(username: json['username'],token:json['token'],role:json['role']);
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["token"] = token;
    map["role"] = role;
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
      {'username': username, 'token': token, 'role': role};
}
