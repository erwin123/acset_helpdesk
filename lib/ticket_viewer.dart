import 'dart:convert';
import 'dart:io';

import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:flutter/material.dart';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;
import 'package:http/io_client.dart';

class TicketViewer extends StatefulWidget {
  final int viewerType;
  TicketViewer({Key key, this.viewerType}) : super(key: key);
  @override
  _TicketViewerState createState() => _TicketViewerState();
}

class _TicketViewerState extends State<TicketViewer> {
  var tickets;
  SharedPref sharedPref = SharedPref();
  CredentialModel credential;
  String title = "My Request";
  int viewerType;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTicket();

    });
    setState(() {
      viewerType = widget.viewerType;
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

  Future loadTicket() async {
    this.onLoading((context) async {
      Map<String, dynamic> map = await sharedPref.read("credential");
      setState(() {
        credential = CredentialModel.fromJson(map);
      });
      String URL = globalVariables.BASE_URL + '/ticket/IT/ticket_cr'; //dev
      //String URL = globalVariables.BASE_URL + '/ticket/ticket_cr';
      var crit = {"createBy": "ACSET\\" + credential.username};
      print(viewerType);
      switch (viewerType) {
        case 1: //my request
          title = "My Request";
          crit = {"createBy": "ACSET\\" + credential.username};
          break;
        case 2://my task
          title = "My Task";
          crit = {"asignTo": "ACSET\\" + credential.username};
          break;
        case 3://assigner
          title = "Ticket Assigner";
          crit = {"tStat": "0"};
          break;
        default:
          title = "My Request";
          crit = {"createBy": "ACSET\\" + credential.username};
          break;
      }

      String jsonBody = json.encode(crit);
      print('jsonBody: ${jsonBody}');
      final encoding = Encoding.getByName('utf-8');

      bool trustSelfSigned = true;
      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
      IOClient ioClient = new IOClient(httpClient);

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
        var responseJson = json.decode(response.body);
        setState(() {
          tickets = (responseJson as List).toList();
          Navigator.pop(context);
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 40 ),
                    ))),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: tickets != null ? tickets.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 50,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      color: Colors.white,
                      //child: Center(child: Text(tickets[index]["tID"]))
                      child: Row(
                        children: <Widget>[
                          Text(tickets[index]["tID"]),
                          SizedBox(width: 20),
                          Text(
                            tickets[index]["tProblem"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ));
                })
          ],
        )));
  }
}
