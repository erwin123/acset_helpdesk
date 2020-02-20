import 'package:acset_helpdesk/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _username;
//  void initState() {
//    super.initState();
//    WidgetsBinding.instance
//        .addPostFrameCallback((_) => checkLoggedIn());
//  }

//  checkLoggedIn(){
////    var loggedIn = Provider.of<AuthService>(context, listen: false)
////        .checkInternalStore();
//    print(true);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                padding: EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('member.jpg'), fit: BoxFit.cover)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 95.0),
                      Row(
                        children: <Widget>[

                          Text("Helpdesk", textAlign: TextAlign.right, style: TextStyle(fontSize: 20, color: Colors.white),),
                          Expanded(flex: 1, child:Container(width: 100))
                        ],
                      ),

                      Image(image: AssetImage('logo.png')),
                      SizedBox(height: 55.0),
                      myTextField("Username", (val) {_username = val;}),
                      SizedBox(height: 25.0),
                      myTextField("Password", (val) {_password = val;},
                          obscureText: true),
                      SizedBox(height: 35.0),
                      myButton("LOGIN", () {
                        final form = _formKey.currentState;
                        form.save();
                        print(form.validate());
                        if (form.validate()) {
                          print("$_username $_password");
                          Provider.of<AuthService>(context, listen: false)
                              .loginUser(username: _username, password: _password).then((val){
                            if(val == null){
                              this.myAlert("Username or password not match");
                            }
                          });
                        }else{

                        }
                      }
                      )
                    ],
                  ),
                ))));
  }

  Future<void> myAlert(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              textColor: Color(0xff000000),
              color: Color(0xffffcc00),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  myTextField(placeholder, Function func, {bool obscureText = false}) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return placeholder+' required';
        }
        return null;
      },

      onSaved: (value) => func(value),
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: placeholder,
//                      fillColor: Colors.white,
//                      filled: true,
        labelStyle: TextStyle(color: Colors.white),
        errorBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Color(0xffffcc00)),
          borderRadius: new BorderRadius.circular(0.0),
        ),
        errorStyle: TextStyle(color: Color(0xffffcc00)),
        focusedBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.white),
          borderRadius: new BorderRadius.circular(0.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.white),
          borderRadius: new BorderRadius.circular(8),
        ),
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(0.0),
          ),
          borderSide: new BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  myButton(text, Function func) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(8.0),
      color: Color(0xffffcc00),
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          func();
//          final form = _formKey.currentState;
//          form.save();
//          if (form.validate()) {
//            print("$_username $_password");
//            Provider.of<AuthService>(context, listen: false)
//                .loginUser(
//                username: _username, password: _password);
//          }
        },
        child: Text(
          "LOGIN",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  myText(inputText) {
    return Text(
      inputText,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}
