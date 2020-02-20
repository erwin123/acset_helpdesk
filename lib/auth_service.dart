import 'dart:async';
import 'dart:convert';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/model/login.dart';
import 'package:acset_helpdesk/services/abstract_request.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:flutter/material.dart';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  var currentUser;
  CredentialModel credential;
  SharedPref sharedPref = SharedPref();
  AbstractRequest abr = new AbstractRequest();
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

  // logs in the user if password matches
  Future loginUser({String username, String password}) async {
    LoginModel loginModel = new LoginModel();
    loginModel.username = username;
    loginModel.password = password;
    String jsonBody = json.encode(loginModel.toMap());
    final response =  await abr.postNoToken('/user/IT/login', jsonBody);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print(CredentialModel.fromJson(map).ur);
      this.credential = CredentialModel.fromJson(map);
      await sharedPref.save("credential", CredentialModel.fromJson(map).toJson());
      notifyListeners();
      return Future.value(this.credential);
    }else{
      Future.value(null);
      return Future.value(null);
    }
  }
}