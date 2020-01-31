import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acset_helpdesk/auth_service.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: Drawer(
        elevation: 5,
      ),
      appBar: AppBar(
        title:Row(
            children: [
              Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                height: 32,
              )
            ]),
        backgroundColor: new Color(0xff283271),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: (){
                Future result = Provider.of<AuthService>(context, listen: false).logout();
                print(result);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home Page Flutter Firebase  Content'),
      ),
    );
  }
}