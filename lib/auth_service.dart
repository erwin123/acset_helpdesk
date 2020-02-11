import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/model/login.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:flutter/material.dart';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AuthService with ChangeNotifier {
  var currentUser;
  CredentialModel credential;
  SharedPref sharedPref = SharedPref();
  AuthService() {
    print("new AuthService");
  }

  isLogin() async {
    //CredentialModel checkCredential = new CredentialModel();
    try {
      print("SET TO PREFS. . . . . .");
      this.credential = CredentialModel.fromJson(await sharedPref.read("credential"));
    } catch (Exception) {
      print("FAILED AUTO LOGIN. . . . . .");
      return;
    }
  }

  Future getUser() {
    //this.currentUser = isLogin() ? prefs.get("username") : null;
    this.isLogin();
    return Future.value(this.credential);
  }

  // wrappinhg the firebase calls
  Future logout() async {
    this.credential = null;
    sharedPref.remove("credential");
    notifyListeners();
    return Future.value(credential);
  }

  // wrapping the firebase calls
//  Future createUser(
//      {String firstName,
//        String lastName,
//        String email,
//        String password}) async {}

  // logs in the user if password matches
  Future loginUser({String username, String password}) async {
    String URL = globalVariables.BASE_URL+ '/user/IT/login' ; //dev
    //String URL = globalVariables.BASE_URL+ '/user/login' ;
    LoginModel loginModel = new LoginModel();
    loginModel.username = username;
    loginModel.password = password;

    String jsonBody = json.encode(loginModel.toMap());
    //print('jsonBody: ${jsonBody}');
    final encoding = Encoding.getByName('utf-8');
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.post(
    //final response = await http.post(
      URL,
      headers: {"Content-Type": "application/json"},
      body: jsonBody,
      encoding: encoding,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print(CredentialModel.fromJson(map).name);
//      sharedPref.saveString("token", map["token"]);
//      sharedPref.saveString("username", map["username"]);
//      sharedPref.saveString("role", map["ur"]);
//      sharedPref.saveString("email", map["email"]);
      this.credential = CredentialModel.fromJson(map);
      await sharedPref.save("credential", CredentialModel.fromJson(map).toJson());
      notifyListeners();
      return Future.value(this.credential);
    }else{
      Future.value(null);
      return Future.value(null);
    }
//    if (password == 'password123') {
//      this.credential = new CredentialModel(username: username, token: "token", role:"role");
//      sharedPref.save("credential", this.credential);
//      notifyListeners();
//      return Future.value(this.credential);
//    } else {
//      this.credential = null;
//      sharedPref.save('credential', null);
//      return Future.value(null);
//    }
  }
}