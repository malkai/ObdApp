import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_prov;
import '../dataBaseClass/vehiclesUser.dart';
import '../widgets/historyrideruserWidget.dart';

class HistoryUserWidget extends StatefulWidget {
  const HistoryUserWidget({super.key});

  @override
  State<HistoryUserWidget> createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUserWidget> {
  List<dynamic> help1 = [];
  var userlist;
  bool bb = true;
  late Box confapp;

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

  void deletePath(var data) async {
    var bb = await path_prov.getApplicationDocumentsDirectory();
    Box teste = await Hive.openBox<UserVehicles>('userdata', path: bb.path);
    print(data);
    teste.deleteAt(data);
    teste.close();
    aux().then(
      (value) => setState(
        () {
          help1 = value;
        },
      ),
    );
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
        ? Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 30),
                FloatingActionButton(
                  heroTag: "btn01",
                  backgroundColor: (const Color(0xFF26B07F)),
                  child: const Icon(
                    Icons.sync,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    help1 = await aux();
                    print(help1.length);
                    setState(() {
                      help1;
                    });
                  },
                ),
              ],
            ),
            body: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
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
                          if (help1[i].vehicle.kmarre.length > 0 &&
                              help1[i].vehicle.kmacce > 0) {}
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
                                    const Icon(Icons.directions_car,
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
                                      const Icon(Icons.calendar_month,
                                          color: Colors.black, size: 15),
                                      Text(help1[i].vehicle.time.toString()),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.timer,
                                          color: Colors.black, size: 15),
                                      Text(
                                          '${' ' + help1[i].vehicle.tacc.toStringAsFixed(3)} s'),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  const Color(0xFF26B07F)),
                                        ),
                                        child: const Text(
                                          'Deletar',
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 20.0),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            //if set to true allow to close popup by tapping out of the popup

                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: Text(
                                                  "Deseja deletar o arquivo"),
                                              content: Text(
                                                  help1[i].vehicle.id +
                                                      '\n' +
                                                      help1[i]
                                                          .vehicle
                                                          .time
                                                          .toString()),
                                              actions: [
                                                ElevatedButton(
                                                  child: Text("Yes"),
                                                  onPressed: () {
                                                    deletePath(i);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                              elevation: 24,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 30),
                FloatingActionButton(
                  heroTag: "btn01",
                  backgroundColor: (const Color(0xFF26B07F)),
                  child: const Icon(
                    Icons.sync,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    help1 = await aux();
                    print(help1.length);
                    setState(() {
                      help1;
                    });
                  },
                ),
              ],
            ),
            body: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          );
  }

  TableRow buildRow(List<String> cells) =>
      TableRow(children: cells.map((e) => Text(e)).toList());
}
