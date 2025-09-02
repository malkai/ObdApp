import 'package:flutter/material.dart';

class pathwidger extends StatefulWidget {
  String n;
  String dist;
  String Comb;
  String Date;
  String timeless;
  pathwidger({required this.n,required this.dist, required this.Comb, required this.Date,  required this.timeless, super.key});

  @override
  State<pathwidger> createState() => _pathwidgerState();
}

class _pathwidgerState extends State<pathwidger> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 120 * MediaQuery.textScalerOf(context).scale(1),
        width: 300 * MediaQuery.textScalerOf(context).scale(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(
                255, 173, 173, 173), // Set the border color
            width: 1.0, // Set the border width
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    child: Text("Trajeto "+ widget.n, style: TextStyle(fontSize: 18.0))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distancia'),
                    Text('Combustivel'),
                    Text('Date'),
                    Text('Timeless'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.dist),
                    Text(widget.Comb),
                    Text(widget.Date),
                    Text(widget.timeless),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
