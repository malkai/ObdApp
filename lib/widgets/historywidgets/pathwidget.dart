import 'package:flutter/material.dart';
import 'package:obdapp/widgets/MapGpswidget.dart';
import 'package:latlong2/latlong.dart';

class pathwidger extends StatefulWidget {
  List pointswidger;
  String n;
  String dist;
  String fuel;
  String Date;
  String timeless;
  pathwidger(
      {required this.n,
      required this.dist,
      required this.fuel,
      required this.Date,
      required this.timeless,
      required this.pointswidger,
      super.key});

  @override
  State<pathwidger> createState() => _pathwidgerState();
}

class _pathwidgerState extends State<pathwidger> {
  List<LatLng> points = [];

  void init() async {
    print("init map");
    for (int i = 0; i < widget.pointswidger.length; i++) {
      print(widget.pointswidger[i]);
      print(widget.pointswidger[i]["lat"]);
      print(widget.pointswidger[i]["long"]);
      LatLng aux = LatLng(double.parse(widget.pointswidger[i]["lat"]),
          double.parse(widget.pointswidger[i]["long"]));
      points.add(aux);
    }
    //  LatLng aux = LatLng(roundDouble(actualPosition.latitude, 4),
    //    roundDouble(actualPosition.longitude, 4));
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 340 * MediaQuery.textScalerOf(context).scale(1),
        width: 300 * MediaQuery.textScalerOf(context).scale(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
                    child: Text("Trajeto " + widget.n,
                        style: TextStyle(fontSize: 18.0))),
              ],
            ),
               Container(
                  height: 300,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MapWidget(points: points),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(
                          255, 173, 173, 173), // Set the border color
                      width: 1.0, // Set the border width
                    ),
                  ),
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
                    Text(widget.fuel),
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
