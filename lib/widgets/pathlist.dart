import 'package:flutter/widgets.dart';
import 'package:obdapp/widgets/pathwidget.dart';

class Pathlist extends StatefulWidget {
  String number;
  
  String date;
  List<Path> Paths;
  Pathlist(
      {required this.number,
      required this.date,
      required this.Paths,
      super.key});

  @override
  State<Pathlist> createState() => _PathlistState();
}

class _PathlistState extends State<Pathlist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Evento" + widget.number, style: TextStyle(fontSize: 14.0)),
            Text("Date " + widget.date, style: TextStyle(fontSize: 14.0)),
          ],
        ),
        Column(
          children: [
            pathwidger(n: "1",dist: "10 M", Comb: "10 L", Date: "xx/xx/xxxx", timeless: "10%",),
            pathwidger(n: "2",dist: "10 M", Comb: "10 L", Date: "xx/xx/xxxx", timeless: "10%",),
            pathwidger(n: "3",dist: "10 M", Comb: "10 L", Date: "xx/xx/xxxx", timeless: "10%",),
          ],
        ),
      ],
    );
  }
}
