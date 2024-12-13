import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../functions/obdPlugin.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:obdapp/functions/InternalDatabase.dart';
import 'package:obdapp/route/autoroute.dart';
import '/functions/obdPlugin.dart';
import '/widgets/roadMapUserWidget.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/dataConnect.dart';

@RoutePage()
class obddata extends StatefulWidget {
  final ObdPlugin obd2;

  final bool logic;
  const obddata({super.key, required this.obd2, required this.logic});

  @override
  State<obddata> createState() => _OBDdataState();
}

class _OBDdataState extends State<obddata> {
  double heigh1 = 200;

  List<LatLng> points = [];

  @override
  void dispose() {
    super.dispose();
  }

  void updatemap() {
    setState(() {
      points;
    });
    print(points.length);
  }

  bool statewidget = true;

  void changestate() {
    statewidget = !statewidget;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: (const Color(0xFF26B07F)),
              heroTag: "btn1",
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                changestate();

                //Apploadingrouter()
                var bancoInterno = InternalDatabase();
                await bancoInterno.handledata().then((value) {
                  context.router.popUntilRoot();
                });

                //
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Builder(builder: (BuildContext context) {
              return points.length > 1
                  ? MapWidget(points: points)
                  : Container(
                      color: Colors.brown[50],
                    );
            }),
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
                        updatemap: updatemap,
                        statewidget: statewidget,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
