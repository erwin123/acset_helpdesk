import 'package:flutter/material.dart';

class TicketViewer extends StatefulWidget {

  @override
  _TicketViewerState createState() => _TicketViewerState();
}

class _TicketViewerState extends State<TicketViewer> {
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:Container(
      child: Column(
        children: <Widget>[
          Text("This is Ticket Viewer")
        ],
      ),
    )
    );
  }
}