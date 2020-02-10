import 'dart:convert';

import 'package:acset_helpdesk/create_ticket.dart';
import 'package:acset_helpdesk/main_fragment.dart';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:acset_helpdesk/ticket_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acset_helpdesk/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CredentialModel credential;
  SharedPref sharedPref = SharedPref();
  int selectedView=2;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadPref());
  }

  void loadPref() async {
    this.onLoading((context) async {
      Map<String, dynamic> map = await sharedPref.read("credential");
      new Future.delayed(new Duration(milliseconds: 100), () {
        setState(() {
          this.credential = CredentialModel.fromJson(map);
          Navigator.pop(context);
        });
      });
    });
  }

  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new MainFragment();
      case 1:
        return new TicketViewer();
      case 2:
        return new CreateTicket();
    }
  }

  void onLoading(Function func) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 5,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 20),
            Row(mainAxisSize: MainAxisSize.max, children: [
              new SizedBox(
                width: 20,
              ),
              new CircularProgressIndicator(),
              new SizedBox(
                width: 10,
              ),
              new Text("Loading"),
              new SizedBox(
                width: 20,
              )
            ]),
            SizedBox(height: 20)
          ]),
        );
      },
    );
    func(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          elevation: 5,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bg-profile.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 1.0,
                                    // has the effect of softening the shadow
                                    spreadRadius: 1.0,
                                    // has the effect of extending the shadow
                                    offset: Offset(
                                      0.0, // horizontal, move right 10
                                      0.0, // vertical, move down 10
                                    ),
                                  )
                                ]),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset('assets/profile.png',
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100)),
                          ),
                        ])),
                Text("Welcome, ", style: TextStyle(fontSize: 20)),
                Text(this.credential == null ? "" : this.credential.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Create Ticket'),
                  onTap: () {
                    setState(() {
                      selectedView = 2;
                    });
                    Navigator.pop(context);
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('My Request'),
                  onTap: () {
                    setState(() {
                      selectedView = 1;
                    });
                    Navigator.pop(context);
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('My Task'),
                  onTap: () {
                    setState(() {
                      selectedView = 1;
                    });
                    Navigator.pop(context);
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          )),
      appBar: AppBar(
        title: Row(children: [
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
            onPressed: () {
              Future result =
                  Provider.of<AuthService>(context, listen: false).logout();
              print(result);
            },
          ),
        ],
      ),
      body: getDrawerItemWidget(selectedView)
    );
  }
}
