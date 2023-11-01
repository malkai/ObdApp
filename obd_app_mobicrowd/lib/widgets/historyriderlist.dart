import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_prov;
import '../dataBaseClass/vehiclesUser.dart';
import 'historyRiderUserWidget.dart';
import 'package:intl/intl.dart';

class HistoryUserWidget extends StatefulWidget {
  const HistoryUserWidget({Key? key}) : super(key: key);

  @override
  State<HistoryUserWidget> createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUserWidget> {
  List<dynamic> help1 = [];
  var userlist;
  bool bb = true;

  Future<List> aux() async {
    var bb = await path_prov.getApplicationDocumentsDirectory();
    Box teste = await Hive.openBox<UserVehicles>('userdata', path: bb.path);

    List help = teste.values.toList();
    return help;
  }

  OverlayEntry? entry;
  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  void showOverlay() {
    try {
      entry = OverlayEntry(
          builder: (context) =>
              HistoryRideUser(hide: hideOverlay, userlist: userlist));
      var overlay = Overlay.of(context);
      overlay.insert(entry!);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    aux().then(
      (value) => setState(
        () {
          help1 = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return help1.isNotEmpty
        ? Container(
            color: Colors.brown[50],
            child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: help1.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onDoubleTap: () {
                          if (help1[i].vehicle.kmarrh.length > 0 &&
                              help1[i].vehicle.kmacch > 0) {}
                          setState(() {
                            userlist = help1[i];
                          });

                          showOverlay();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.directions_car,
                                        color: Colors.black, size: 30),
                                    Text(' ' + help1[i].vehicle.id),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_month,
                                              color: Colors.black, size: 15),
                                          Text(' ' +
                                              DateFormat('dd-MM-yyyy')
                                                  .format(help1[i].vehicle.time)
                                                  .toString()),
                                          SizedBox(width: 10),
                                          Icon(Icons.timer,
                                              color: Colors.black, size: 15),
                                          Text(' ' +
                                              help1[i]
                                                  .vehicle
                                                  .tacc
                                                  .toStringAsFixed(3) +
                                              ' s'),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          )
        : Container(
            color: Colors.brown[50],
          );
  }

  TableRow buildRow(List<String> cells) =>
      TableRow(children: cells.map((e) => Text(e)).toList());
}
