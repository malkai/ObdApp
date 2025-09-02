import 'package:flutter/material.dart';
import 'package:obdapp/widgets/pathlist.dart';
import 'package:obdapp/widgets/pathwidget.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  @override
  bool show = true;
  List<Path> Paths = [];

  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Eventos", style: TextStyle(fontSize: 20.0)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              onPressed: () {
                show = false;
                setState(() {});
              },
              child: Text('Open Event'),
            ),
            OutlinedButton(
              onPressed: () {
                show = true;
                setState(() {});
              },
              child: Text('Close Event'),
            ),
          ],
        ),
        if (show == true)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Pathlist(
              number: "1 ",
              date: " xx/xx/xxxx",
              Paths: [],
            ),
          ),
        if (show == false)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Pathlist(
              number: " 2 ",
              date: " xx/xx/xxxx",
              Paths: [],
            ),
          ),
      ],
    );
  }
}

//http://10.26.106.199:3000
//0x4288201baC903F84648E81A07F793C9E7d893692
