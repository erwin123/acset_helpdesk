import 'package:acset_helpdesk/auth_service.dart';
import 'package:acset_helpdesk/home_page.dart';
import 'package:acset_helpdesk/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider<AuthService>(
    child: MyApp(),
    create: (BuildContext context) {
      return AuthService();
    },
  ),
);
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Login'),
      home: FutureBuilder(
        // get the Provider, and call the getUser method
        future: Provider.of<AuthService>(context).getUser(),
        // wait for the future to resolve and render the appropriate
        // widget for HomePage or LoginPage
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData ? HomePage() : LoginPage();
          } else {
            return Container(color: Colors.white);
          }
        },
      ),
    );
  }
}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//
//  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
//
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    final emailField = TextField(
//      obscureText: false,
//      style: style,
//      decoration: InputDecoration(
//          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//          hintText: "Email",
//          border:
//          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
//    );
//    final passwordField = TextField(
//      obscureText: true,
//      style: style,
//      decoration: InputDecoration(
//          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//          hintText: "Password",
//          border:
//          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
//    );
//    final loginButton = Material(
//      elevation: 5.0,
//      borderRadius: BorderRadius.circular(30.0),
//      color: Color(0xff01A0C7),
//      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
//        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//        onPressed: () {},
//        child: Text("Login",
//            textAlign: TextAlign.center,
//            style: style.copyWith(
//                color: Colors.white, fontWeight: FontWeight.bold)),
//      ),
//    );
//
//
//    return Scaffold(
//      body: Center(
//        child: Container(
//          color: Colors.white,
//          child: Padding(
//            padding: const EdgeInsets.all(36.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                SizedBox(
//                  height: 155.0,
//                  child: Image.asset(
//                    "assets/logo.png",
//                    fit: BoxFit.contain,
//                  ),
//                ),
//                SizedBox(height: 45.0),
//                emailField,
//                SizedBox(height: 25.0),
//                passwordField,
//                SizedBox(
//                  height: 35.0,
//                ),
//                loginButton,
//                SizedBox(
//                  height: 15.0,
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}