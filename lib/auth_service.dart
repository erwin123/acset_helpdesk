import 'dart:async';
import 'dart:convert';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService with ChangeNotifier {
  var currentUser;
  CredentialModel credential;
  SharedPreferences prefs;
  AuthService() {
    print("new AuthService");
  }

  isLogin() async {

    prefs = await SharedPreferences.getInstance();

    if(prefs.get("credential")==""||prefs.get("credential")==null){
      print("FAILED AUTO LOGIN. . . . . .");
      return;
    }
    else{
      //prefs.clear();
      print("SET TO PREFS. . . . . .");
      print(CredentialModel.fromJson(this.prefs.get("credential")));
      //this.credential = CredentialModel.fromJson(credentialMap);
      print(this.credential);
    }
  }

  Future getUser() async {
    //this.currentUser = isLogin() ? prefs.get("username") : null;
    await this.isLogin();
    return Future.value(this.credential);
  }

  // wrappinhg the firebase calls
  Future logout() async {
    prefs = await SharedPreferences.getInstance();
    this.credential = null;
    this.prefs.clear();
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
    prefs = await SharedPreferences.getInstance();
    if (password == 'password123') {
      this.credential = new CredentialModel(username:username,token:'token',role:'role');
      //print(jsonEncode(this.credential.toJson()));
      Map decode_options = jsonDecode(jsonEncode(this.credential.toJson()));
      String dt = jsonEncode(CredentialModel.fromJson(decode_options));
      this.prefs.setString("credential", dt);
      notifyListeners();
      return Future.value(this.credential);
    } else {
      this.credential = null;
      this.prefs.setString('credential', null);
      return Future.value(null);
    }
  }
}