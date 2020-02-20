import 'dart:convert';
import 'dart:io';

import 'package:acset_helpdesk/model/category.dart';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/services/abstract_request.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:acset_helpdesk/ticket_detail.dart';
import 'package:flutter/material.dart';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class TicketViewer extends StatefulWidget {
  final int viewerType;

  TicketViewer({Key key, this.viewerType}) : super(key: key);

  @override
  _TicketViewerState createState() => _TicketViewerState();
}

class _TicketViewerState extends State<TicketViewer> {
  var tickets;
  var originalTickets;
  List<CategoryModel> cat = new List<CategoryModel>();
  SharedPref sharedPref = SharedPref();
  CredentialModel credential;
  String title = "My Request";
  int viewerType;
  String _searchText = "";
  AbstractRequest abr = new AbstractRequest();
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map<String, dynamic> map = await sharedPref.read("credential");
      setState(() {
        credential = CredentialModel.fromJson(map);
      });
      loadTicket();
      loadCategory();
    });
    setState(() {
      print(viewerType);
      viewerType = widget.viewerType;
    });
  }

  Future loadCategory() async {
    var crit = {};
    String jsonBody = json.encode(crit);
    final response = await abr.post('/category/IT/category_cr', jsonBody);
    if (response.statusCode == 200) {
      //Map<String, dynamic> map = json.decode(response.body);
      var responseJson = json.decode(response.body);
      setState(() {
        cat = (responseJson as List)
            .map((p) => CategoryModel.fromJson(p))
            .toList();
      });
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

  Future<void> viewDetail(Object ticket, Function func) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[TicketDetail(ticket: ticket)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              textColor: Color(0xff000000),
              color: Color(0xffffcc00),
              onPressed: () {
                Navigator.of(context).pop();
                func();
              },
            ),
          ],
        );
      },
    );
  }

  Future loadTicket() async {
    this.onLoading((context) async {
      var crit = {"createBy": "ACSET\\" + credential.username};
      print(viewerType);
      switch (viewerType) {
        case 0: //all active ticket
          title = "Ticket Active";
          crit = {"tStat": "2"};
          break;
        case 1: //my request
          title = "My Request";
          crit = {"createBy": "ACSET\\" + credential.username};
          break;
        case 2: //my task
          title = "My Task";
          crit = {"asignTo": "ACSET\\" + credential.username};
          break;
        case 3: //assigner
          title = "Ticket Assigner";
          crit = {"tStat": "0"};
          break;
        default:
          title = "My Request";
          crit = {"createBy": "ACSET\\" + credential.username};
          break;
      }

      String jsonBody = json.encode(crit);
      final response = await abr.post('/ticket/IT/ticket_cr', jsonBody);

      if (response.statusCode == 200) {
        //Map<String, dynamic> map = json.decode(response.body);
        var responseJson = json.decode(response.body);
        setState(() {
          tickets = (responseJson as List).toList();
          if (viewerType == 0) {
            appendPending().then((v) {
              tickets.addAll(v);
            });
          } else
            tickets = (responseJson as List).toList();
          originalTickets = tickets;
          Navigator.pop(context);
        });
      }
    });
  }

  myTextField(placeholder, Function func, {bool isNumber = false}) {
    return TextFormField(

      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        isNumber
            ? WhitelistingTextInputFormatter.digitsOnly
            : WhitelistingTextInputFormatter(RegExp("."))
      ],
      validator: (value) {
        if (value.isEmpty) {
          return placeholder + ' required';
        }
        return null;
      },
      onChanged: (value) => func(value),
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
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
    );
  }

  Future appendPending() async {
    var critAppend = {"tStat": "3"};
    String jsonBody2 = json.encode(critAppend);
    final response2 = await abr.post('/ticket/IT/ticket_cr', jsonBody2);
    return Future.value((json.decode(response2.body) as List).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 40),
                        ))),
                if (tickets != null)
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: myTextField("Ticket No...", (val) {

                      if (val != "") {
                        setState(() {
                          _searchText = val;
                          tickets = tickets
                              .where(
                                  (r) => r["tID"].toString().indexOf(val) > -1)
                              .toList();
                        });
                      } else {
                        setState(() {
                          tickets = originalTickets;
                        });
                      }
                    }),
                  ),
                if (tickets != null)
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: tickets != null ? tickets.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            //onTap: () => viewDetail(tickets[index], (_)=>{}),
                            onTap: () {
                              print(tickets[index]["tID"]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TicketDetail(ticket: tickets[index])),
                              );
                            },
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(5),
                                    color: Colors.white,
                                    //child: Center(child: Text(tickets[index]["tID"]))
                                    child: Row(
                                      children: <Widget>[
                                        Text(tickets[index]["tID"]),
                                        SizedBox(width: 20),
//                                        Text(
//                                          cat
//                                              .where((r) =>
//                                                  r.pId ==
//                                                  tickets[index]["pCat"])
//                                              .toList()[0]
//                                              .pDesc,
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold),
//                                        )
                                        Text(tickets[index]["Cat"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ))));
                      }),
                if (tickets == null || tickets.length == 0)
                  Text(
                    "No data found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
              ],
            )));
  }
}
