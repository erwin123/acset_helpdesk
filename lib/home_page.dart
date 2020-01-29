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
      appBar: AppBar(
        title: Text("Home Flutter Firebase"),
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