import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/functions/obdPlugin.dart';
import '/widgets/roadMapUserWidget.dart';
import 'package:latlong2/latlong.dart';
import '../autoroute/autoroute.gr.dart';
import 'dataConnect.dart';


class ObdDataMap extends StatefulWidget {
  final ObdPlugin obd2;
  Function() turnOBD_OFF;
  bool help;
  ObdDataMap(
      {Key? key,
      required this.obd2,
      required this.turnOBD_OFF,
      required this.help})
      : super(key: key);

  @override
  State<ObdDataMap> createState() => _ObdDataMapState();
}

class _ObdDataMapState extends State<ObdDataMap> {
  double heigh1 = 200;

  List<LatLng> points = [];

  @override
  void dispose() {
    super.dispose();
  }

  bool statewidget = true;

  void changestate() {
    statewidget = !statewidget;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Builder(builder: (BuildContext context) {
            return points.isNotEmpty
                ? MapWidget(points: points)
                : Container(
                    color: Colors.brown[50],
                  );
          }),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: FloatingActionButton(
                child: const Icon(Icons.arrow_back),
                onPressed: () async {
                  changestate();
                  await widget.turnOBD_OFF();
            
                  //Apploadingrouter()
                  context.router.pop().then(
                      (value) => context.router.replace(const Apploadingrouter()));
            
                  //
                }),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      if (heigh1 == 200) {
                        heigh1 = 50;
                      } else {
                        heigh1 = 200;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: heigh1,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Data_Connect(
                      points: points,
                      obd2: widget.obd2,
                      turnOBD_OFF: widget.turnOBD_OFF,
                      statewidget: statewidget,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
