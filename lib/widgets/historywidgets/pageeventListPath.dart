import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:obdapp/route/autoroute.dart';
import 'package:obdapp/widgets/historywidgets/pathwidget.dart';

@RoutePage()
class eventListPath extends StatelessWidget {
  var event;
  int index;

  eventListPath({required this.event, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "btninit2",
                  backgroundColor: Color(0xFF26B07F),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    AutoRouter.of(context).popForced();
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Evento " + index.toString(),
                          style: TextStyle(fontSize: 25.0)),
                      Text(event.value + " MLK",
                          style: TextStyle(fontSize: 25.0)),
                    ],
                  ),
                  Container(
                    height: 700,
                    width: 400,
                    child: ListView(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: event.paths.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: pathwidger(
                                pointswidger: event.paths[index].arrlatlong,
                                n: index.toString(),
                                dist: event.paths[index].dist,
                                fuel: event.paths[index].fuel,
                                Date: event.paths[index].time,
                                timeless: event.paths[index].timeless,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
