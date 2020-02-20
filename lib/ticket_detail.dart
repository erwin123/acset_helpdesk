import 'dart:convert';
import 'dart:io';

import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/model/users.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:acset_helpdesk/services/abstract_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;
import 'package:http/io_client.dart';

class TicketStatus {
  final String tStat;
  final String desc;

  TicketStatus(this.tStat, this.desc);
}

class TicketDetail extends StatefulWidget {
  final ticket;

  TicketDetail({Key key, this.ticket}) : super(key: key);

  @override
  _TicketDetailState createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  var ticket;
  SharedPref sharedPref = SharedPref();
  CredentialModel credential;
  String displayStatus = "";
  String selectedPIC;
  String selectedStat;
  AbstractRequest abr = new AbstractRequest();
  List<UsersModel> pics = new List<UsersModel>();
  List<TicketStatus> ticketStatus = new List<TicketStatus>();
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadPIC("AD");
      await loadPIC("SP");
      Map<String, dynamic> map = await sharedPref.read("credential");

      setState(() {
        ticket = widget.ticket;
        credential = CredentialModel.fromJson(map);
        ticketStatus.add(new TicketStatus("0", "Open"));
        ticketStatus.add(new TicketStatus("1", "Need Approval"));
        ticketStatus.add(new TicketStatus("2", "Assigned"));
        ticketStatus.add(new TicketStatus("3", "Pending"));
        ticketStatus.add(new TicketStatus("6", "Re-Open"));
        ticketStatus.add(new TicketStatus("8", "Cancel"));
        ticketStatus.add(new TicketStatus("7", "Solved"));
        ticketStatus.add(new TicketStatus("9", "Close"));
        selectedStat = ticket["tStat"];
        selectedPIC = ticket["asignTo"] == "" || ticket["asignTo"] == null ? null: ticket["asignTo"];
        switch (ticket["tStat"]) {
          case "0":
            displayStatus = "Open";
            break;
          case "1":
            displayStatus = "Need Approval";
            break;
          case "2":
            displayStatus = "Assigned";
            break;
          case "3":
            displayStatus = "Pending";
            break;
          case "6":
            displayStatus = "Re-Open";
            break;
          case "7":
            displayStatus = "Solved";
            break;
          case "8":
            displayStatus = "Cancel";
            break;
          case "9":
            displayStatus = "Close";
            break;
        }
      });
    });
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

  Future loadPIC(role) async {
    var crit = {"pDeptID": "ITD", "deleted": "0", "uType": role};
    String jsonBody = json.encode(crit);
    print('jsonBody: ${jsonBody}');
    final response = await abr.post('/user/IT/user_cr',jsonBody);

    if (response.statusCode == 200) {
      //Map<String, dynamic> map = json.decode(response.body);
      var responseJson = json.decode(response.body);
      setState(() {
        if (pics.length == 0)
          pics = (responseJson as List)
              .map((p) => UsersModel.fromJson(p))
              .toList();
        else
          pics.addAll((responseJson as List)
              .map((p) => UsersModel.fromJson(p))
              .toList());
      });
    }
  }

  myButton(text, Function func) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(8.0),
      color: Color(0xffffcc00),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
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
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  assignTo(selectedPIC, tID) async {
    String URL = globalVariables.BASE_URL + '/ticket/IT/assignto'; //dev
    //String URL = globalVariables.BASE_URL + '/ticket/assignto';

    var crit = {"tID": tID, "asignTo": selectedPIC};
    String jsonBody = json.encode(crit);
    print('jsonBody: ${jsonBody}');
    final encoding = Encoding.getByName('utf-8');

    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    onLoading((context) async {
      final response = await ioClient.post(
        URL,
        headers: {
          "Content-Type": "application/json",
          "x-access-token": credential.token
        },
        body: jsonBody,
        encoding: encoding,
      );
      if (response.statusCode == 200) {
        //Map<String, dynamic> map = json.decode(response.body);
        Navigator.pop(context);
        var responseJson = json.decode(response.body);
        if (responseJson["success"] != null) {
          myAlert("Ticket saved!");
        }
      }
    });
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
              children: <Widget>[Text(message)],
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

  myDDL(placeholder, List list, selectedCat, Function func) {
    //list.add(new CategoryModel(pDesc: "-Select-", pId: null));
    return DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null) {
            return placeholder + ' required';
          }
          return null;
        },
        value: selectedCat == null ? null : selectedCat,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          labelText: placeholder,
//                      fillColor: Colors.white,
//                      filled: true,
          labelStyle: TextStyle(color: Colors.black),
          errorBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.red),
            borderRadius: new BorderRadius.circular(0.0),
          ),
          errorStyle: TextStyle(color: Colors.red),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Color(0xff283271)),
            borderRadius: new BorderRadius.circular(0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Color(0xff283271)),
            borderRadius: new BorderRadius.circular(8),
          ),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(0.0),
            ),
            borderSide: new BorderSide(
              color: Color(0xff283271),
              width: 1.0,
            ),
          ),
        ),
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: (value) {
          func(value);
        },
        items: list);
  }

  @override
  Widget build(BuildContext context) {
    if (ticket == null) {
      return Scaffold(
          appBar: AppBar(
              title: Text("Loading...",
                  style: TextStyle(color: Color(0xff283271))),
            backgroundColor: Colors.white
          ));
    } else if(credential == null){
      return Scaffold(
          appBar: AppBar(
              title: Text("Loading...",
                  style: TextStyle(color: Color(0xff283271)))),
          backgroundColor: Colors.white
      );
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text("Ticket " + ticket["tID"],
              style: TextStyle(color: Color(0xff283271))),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xff283271)),
//        actions: <Widget>[
//          IconButton(
//            color: Color(0xff283271),
//            icon: Icon(Icons.close),
//            tooltip: 'Logout',
//            onPressed: () {
//              Navigator.pop(context);
//            },
//          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Reported Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  Text(ticket["rDate"], style: TextStyle(fontSize: 16)),
                  Text("Creator",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ticket["pName"], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Problem",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ticket["tProblem"], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ticket["tMsg"], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Status",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(displayStatus, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Assign To",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(ticket["asignTo"], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Attachment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 20),
                  if (ticket["pName"] != credential.name || credential.ur == "AD")
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius: new BorderRadius.circular(8.0)),
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          if (pics != null && credential.ur == "AD")
                            myDDL(
                                "PIC",
                                pics.map((UsersModel m) {
                                  return DropdownMenuItem<String>(
                                      value: m.uID, child: Text(m.uName));
                                }).toList(),
                                selectedPIC, (val) {
                              setState(() {
                                selectedPIC = val;
                              });
                            }),
                          SizedBox(height: 25),
                          myDDL(
                              "Status",
                              ticketStatus.map((TicketStatus m) {
                                return DropdownMenuItem<String>(
                                    value: m.tStat, child: Text(m.desc));
                              }).toList(),
                              selectedStat, (val) {
                            setState(() {
                              selectedStat = val;
                            });
                          }),
                          SizedBox(height: 25),
                          if (credential != null)
                            if (credential.ur == "AD")
                              myButton("SAVE", () {
                                assignTo(selectedPIC, ticket["tID"]);
                              }),
//                      if(credential != null)if(credential.ur == "SP")myButton("SOLVED",(){
//                        //assignTo(selectedPIC, ticket["tID"]);
//                      })
                        ],
                      ),
                    )
                ],
              ),
            )),
      );
    }
  }
}
