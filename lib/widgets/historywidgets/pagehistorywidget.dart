import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/blockchain.dart';
import 'package:obdapp/widgets/historywidgets/listCloseEvent.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  @override
  bool show = true;
  List<Path> Paths = [];

  var userpatho;
  var userpathc;

  List<dynamic> userpathopen = [];
  List<dynamic> userpathclose = [];

  String conf = "0";
  String comp = "0";
  String freq = "0";

  Future<void> init() async {
    userpatho = await Hive.openBox<Event>('eventopen');
    userpathc = await Hive.openBox<Event>('eventclose');
    Box userscore = await Hive.openBox<UserScore>('score');

    print(userpathopen.length);

    if (userpatho.isNotEmpty) {
      print("test1");
      userpathopen = userpatho.values.toList();
    } else {
      userpathopen = [];
    }

    if (userpathc.isNotEmpty) {
      print("test2");
      userpathclose = userpathc.values.toList();
    } else {
      userpathclose = [];
    }

    if (userscore.isNotEmpty) {
      UserScore aux = userscore.getAt(0);
      conf = aux.conf;
      comp = aux.comp;
      freq = aux.freq;
      setState(() {});
    }

    print(userpathclose.length);
  }

  @override
  void initState() {
    super.initState();
    init().then((value) {});
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10.0, bottom: 5),
          child: Text("Pontuação", style: TextStyle(fontSize: 25.0)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Container(
            height: 80 * MediaQuery.textScalerOf(context).scale(1),
            width: 400 * MediaQuery.textScalerOf(context).scale(1),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color.fromARGB(
                    255, 190, 190, 190), // Set the border color
                width: 1.0, // Set the border width
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF88de9b)),
                        child: Center(
                            child: Text(comp,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF), fontSize: 20.0))),
                      ),
                      Center(
                          child: Text("Completude",
                              style: TextStyle(fontSize: 15.0))),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF88de9b)),
                        child: Center(
                            child: Text(freq,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF), fontSize: 20.0))),
                      ),
                      Center(
                          child: Text("Frequência",
                              style: TextStyle(fontSize: 15.0))),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF88de9b)),
                        child: Center(
                            child: Text(conf,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF), fontSize: 20.0))),
                      ),
                      Center(
                          child: Text("Confiança",
                              style: TextStyle(fontSize: 15.0))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10.0, bottom: 5),
              child: Text("Eventos", style: TextStyle(fontSize: 25.0)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                backgroundColor:
                    WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
              ),
              onPressed: () {
                show = true;
                setState(() {});
              },
              child: Text(
                'Abertos',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.0),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                backgroundColor:
                    WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
              ),
              onPressed: () {
                show = false;
                print(userpathopen.length);
                setState(() {});
              },
              child: Text(
                'Fechados',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.0),
              ),
            ),
            IconButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                backgroundColor:
                    WidgetStateProperty.all<Color>(const Color(0xFF26B07F)),
              ),
              onPressed: () async {
                blockchain auxblock = blockchain();
                Box userdata = await Hive.openBox<wallet>('wallet');
                wallet user = userdata.getAt(0);
                await auxblock.getpaths(user.add);
                await init();
                setState(() {});
              },
              icon: const Icon(Icons.update,
                  color: Color(0xFFFFFFFF), size: 25), // The icon to display
            ),
          ],
        ),
        if (show && userpathopen.isNotEmpty)
          Column(
            children: [
              ListEventClose(userpath: userpathopen),
              TextButton(
                onPressed: () async {
                  // Action to perform when the button is pressed
                  print("Button Pressed!");
                  Box userdata = await Hive.openBox<wallet>('wallet');
                  wallet user = userdata.getAt(0);

                  Map<String, dynamic> data = {
                    'wallet': user.add,
                  };
                  blockchain auxblock = blockchain();
                  auxblock.postEvent("${user.site}:3000/close/event", data);
                  await auxblock.getpaths(user.add).then((Obj) async {
                    // This code runs after fetchUserData completes successfully
                    userpathopen = [];
                    await init();
                    setState(() {});
                  });
                },
                child: Text("Fechar evento"),
              )
            ],
          ),
        if (show == false && userpathclose.isNotEmpty)
          Column(
            children: [
              ListEventClose(userpath: userpathclose),
              TextButton(
                onPressed: () async {
                  // Action to perform when the button is pressed
                  print("Button Pressed!");
                  Box userdata = await Hive.openBox<wallet>('wallet');
                  wallet user = userdata.getAt(0);

                  Map<String, dynamic> data = {
                    'wallet': user.add,
                  };
                  blockchain auxblock = blockchain();
                  auxblock.postEvent("${user.site}:3000/get/coin", data);
                  await auxblock.getpaths(user.add).then((Obj) async {
                    // This code runs after fetchUserData completes successfully
                    await init();
                    setState(() {});
                  });
                },
                child: Text("Monetizar"),
              )
            ],
          ),
      ],
    );
  }
}

//http://10.26.107.136:3000
//0x4288201baC903F84648E81A07F793C9E7d893692
