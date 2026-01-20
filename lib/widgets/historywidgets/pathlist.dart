import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/widgets/historywidgets/pathwidget.dart';

class Pathlist extends StatefulWidget {
  String number;
  String abastecimento;
  String date;
  String value;
  double completude;
  String add;
  List<PathBlockchain> Paths;
  Pathlist(
      {required this.number,
      required this.add,
      required this.date,
      required this.abastecimento,
      required this.Paths,
      required this.completude,
      required this.value,
      super.key});

  @override
  State<Pathlist> createState() => _PathlistState();
}

class _PathlistState extends State<Pathlist> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.number, style: TextStyle(fontSize: 20.0)),
              
            ],
          ),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Data ", style: TextStyle(fontSize: 15.0)),
              Text("Trajetos ", style: TextStyle(fontSize: 15.0)),
              Text("Completude ", style: TextStyle(fontSize: 15.0)),
              Text("add ", style: TextStyle(fontSize: 15.0)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.date.substring(0, 10),
                  style: TextStyle(fontSize: 15.0)),
              Text(widget.Paths.length.toString(),
                  style: TextStyle(fontSize: 15.0)),
              Text(widget.completude.toString().substring(0, 3) + " %",
                  style: TextStyle(fontSize: 15.0)),
              SizedBox(
                  width: 60.0,
                  child: Text(widget.add,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15.0))),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: 60.0,
                  child: Text(widget.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20.0))),
              Text("MLK", style: TextStyle(fontSize: 20.0)),
            ],
          )
        ],
      ),
    );
  }
}
