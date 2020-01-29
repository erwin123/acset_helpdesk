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
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('member.jpg'), fit: BoxFit.cover)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 1.0),
                      Image(image: AssetImage('logo.png')),
                      SizedBox(height: 55.0),
                      myTextField("Email", (val) => {_email = val}),
                      SizedBox(height: 25.0),
                      myTextField("Password", (val) => {_password = val},
                          type: true),
                      SizedBox(height: 35.0),
                      Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xffffcc00),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            final form = _formKey.currentState;
                            form.save();
                            if (form.validate()) {
                              print("$_email $_password");
                              Provider.of<AuthService>(context, listen: false)
                                  .loginUser(
                                      email: _email, password: _password);
                            }
                          },
                          child: Text(
                            "LOGIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ))));
  }

  myTextField(placeholder, Function func, {bool type = false}) {
    return TextFormField(
      onSaved: (value) => func(value),
      obscureText: type,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: placeholder,
//                      fillColor: Colors.white,
//                      filled: true,
        labelStyle: TextStyle(color: Colors.white),
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

  myText(inputText) {
    return Text(
      inputText,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}
