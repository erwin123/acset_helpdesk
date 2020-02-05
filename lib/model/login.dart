class LoginModel{
  String username;
  String password;

  LoginModel({
    this.username,
    this.password,
  });

  Map toMap(){
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}