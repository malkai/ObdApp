import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obdapp/dataBaseClass/obdRawData.dart';
import 'package:obdapp/functions/obdPlugin.dart';
import 'package:path_provider/path_provider.dart' as path_prov;

import '../dataBaseClass/pidDiscoveryClass.dart';

@RoutePage()
class getselectpids extends StatefulWidget {
  const getselectpids({super.key});

  @override
  State<getselectpids> createState() => _getselectpidsState();
}

class _getselectpidsState extends State<getselectpids> {
  var obd2 = ObdPlugin();
  Timer? _timer;
  List data = [];
  Box? pidDisc;
  var pid = TextEditingController(text: '');
  var length = TextEditingController(text: '');
  var title = TextEditingController(text: '');
  var description = TextEditingController(text: '');

  List allpids = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "0A",
    "0B",
    "0C",
    "0D",
    "0E",
    "0F",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "1A",
    "1B",
    "1C",
    "1D",
    "1E",
    "1F",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "2A",
    "2B",
    "2C",
    "2D",
    "2E",
    "2F",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "3A",
    "3B",
    "3C",
    "3D",
    "3E",
    "3F",
    "40",
    "41",
    "42",
    "43",
    "44",
    "45",
    "46",
    "47",
    "48",
    "49",
    "4A",
    "4B",
    "4C",
    "4D",
    "4E",
    "4F",
    "50",
    "51",
    "52",
    "53",
    "54",
    "55",
    "56",
    "57",
    "58",
    "59",
    "5A",
    "5B",
    "5C",
    "5D",
    "5E",
    "5F",
    "60",
    "61",
    "62",
    "63",
    "64",
    "65",
    "66",
    "67",
    "68",
    "69",
    "6A",
    "6B",
    "6C",
    "6D",
    "6E",
    "6F",
    "70",
    "71",
    "72",
    "73",
    "74",
    "75",
    "76",
    "77",
    "78",
    "79",
    "7A",
    "7B",
    "7C",
    "7D",
    "7E",
    "7F",
    "80",
    "81",
    "82",
    "83",
    "84",
    "85",
    "86",
    "87",
    "88",
    "89",
    "8A",
    "8B",
    "8C",
    "8D",
    "8E",
    "8F",
    "90",
    "91",
    "92",
    "93",
    "94",
    "95",
    "96",
    "97",
    "98",
    "99",
    "9A",
    "9B",
    "9C",
    "9D",
    "9E",
    "9F",
    "A0",
    "A1",
    "A2",
    "A3",
    "A4",
    "A5",
    "A6",
    "A7",
    "A8",
    "A9",
    "AA",
    "AB",
    "AC",
    "AD",
    "AE",
    "AF",
    "C0",
    "C1",
    "C2",
    "C3",
    "C4",
    "C5",
    "C6",
    "C7",
    "C8",
    "C9",
    "CA",
    "CB",
    "CC",
    "CD",
    "CE",
    "CF",
    "D0"
  ];

  List<ObdRawData> responses = [];
  List<dynamic> getresponse = [];

  void init() async {
    pidDisc = await Hive.openBox<pidsDisc>('pidsDisc');

    setState(() {
      getresponse = pidDisc!.values.toList();
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    _timer?.cancel();
    final diretorioUsuario = await path_prov.getExternalStorageDirectory();

    File file = File(
        diretorioUsuario!.path + "/" + DateTime.now().toString() + '.json');

    file.create();
    const JsonEncoder encoder = JsonEncoder();

    final String jsonString = encoder.convert(data);
    file.writeAsStringSync(jsonString);
    obd2.connection?.close();
    obd2.connection?.finish();
    obd2.connection?.dispose();
  }

  void checkpis() async {}

  @pragma('vm:entry-point')
  void obdinfo() async {
    if (!(await obd2.isListenToDataInitialed)) {
      obd2.setOnDataReceived((command, response, requestCode) async {
        List resps = jsonDecode(response);
        List<ObdRawData> responses1 = [];

        if (resps.isNotEmpty) {
          for (var reading in resps) {
            String a = reading['response'];

            ObdData help2 = ObdData(
                unit: reading['unit'], title: reading['title'], response: a);
            ObdRawData help1 = ObdRawData(pid: reading['PID'], obddata: help2);

            responses1.add(help1);
          }
        }

        setState(() {
          responses = responses1;
        });
        String? uniqueid;
      });

      if (obd2.connection?.isConnected != false &&
          obd2.connection?.isConnected != null) {
        await Future.delayed(
          Duration(
            seconds: 60 + await obd2.getParamsFromJSON('''
        [      
            {
                "PID": "01 00",
                "length": 4,
                "title": "PIDs supported [01 - 20]",
                "unit": "",
                "description": "<bit>",
                "status": true, 
                "conversion": true
            },
            {
                "PID": "01 20",
                "length": 4,
                "title": "PIDs supported [21 - 40]",
                "unit": "",
                "description": "<bit>",
                "status": true,
                "conversion": true
            },
            {
                "PID": "01 40",
                "length": 4,
                "title": "PIDs supported [41 - 60]",
                "unit": "",
                "description": "<bit>",
                "status": true, 
                "conversion": true
            },
            {
                "PID": "01 60",
                "length": 4,
                "title": "PIDs supported [61 - 80]",
                "unit": "",
                "description": "<bit>",
                "status": true, 
                "conversion": true
            },
            
            {
                "PID": "01 80",
                "length": 4,
                "title": "PIDs supported [81  - A0]",
                "unit": "",
                "description": "<bit>",
                "status": true,
                "conversion": true
            },
            {
                "PID": "01 A0",
                "length": 4,
                "title": "PIDs supported [A1  - C0]",
                "unit": "",
                "description": "<bit>",
                "status": true,
                "conversion": true
            }
               
        ]
      '''),
          ),
        );
      }
    }
  }

  Future<void> insetpid(int index) async {
    var element = pidsDisc(
        pid: pid.text, title: title.text, lenght: int.parse(length.text));
    element.description = description.text;

    pidDisc = await Hive.openBox<pidsDisc>('pidsDisc');

    if (index != -1) {
      pidDisc!.putAt(index, element);
    } else {
      pidDisc!.add(element);
      getresponse.add(element);
    }

    setState(() {
      getresponse;
    });
  }

  Future<void> deletpid(int index) async {
    pidDisc = await Hive.openBox<pidsDisc>('pidsDisc');
    pidDisc!.deleteAt(index);

    getresponse.removeAt(index);

    setState(() {
      getresponse;
    });
  }

  Future<void> showerror(String erro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TapRegion(
          onTapOutside: (tap) {
            context.router.popForced();
          },
          child: AlertDialog(
            title: const Text(''),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(erro),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void openedit(TextEditingController p, l, t, d, int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.zero,
        actions: [
          TextButton(
            onPressed: () {
              pid.text = "";
              length.text = "";
              title.text = "";
              description.text = "";
              context.router.popForced();
            },
            child: Text('Fechar'),
          ),
          TextButton(
            onPressed: () async {
              if (p.text == "" &&
                  l.text == "" &&
                  t.text == "" &&
                  d.text == "") {
                showerror("Um dos campos está vazio");
              } else if (int.tryParse(p.text) == null) {
                showerror("Erro no Pid");
              } else if (int.tryParse(l.text) == null) {
                showerror("Erro no length");
              } else {
                await insetpid(index).then((onValue) {
                  pid.text = "";
                  length.text = "";
                  title.text = "";
                  description.text = "";
                  context.router.popForced();
                });
              }
            },
            child: Text('Salvar'),
          ),
        ],
        title: Text('Adicionar um PID'),
        content: Container(
          height: 280,
          child: Column(
            children: [
              TextField(
                controller: p,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pid',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: l,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'length',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: t,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'title',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: d,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'description',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: (const Color(0xFF26B07F)),
              heroTag: "btn2",
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                openedit(pid, length, title, description, -1);
              },
            ),
            SizedBox(height: 30),
            FloatingActionButton(
              heroTag: "btn3",
              backgroundColor: (const Color(0xFF26B07F)),
              child: const Icon(
                Icons.bluetooth_searching,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: getresponse.length,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 70,
                          minHeight: 70,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            width: 80,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                    value: getresponse[index].ativo,
                                    onChanged: (newbool) {
                                      setState(() {
                                        getresponse[index].ativo =
                                            !getresponse[index].ativo;
                                      });
                                    }),
                                SizedBox(width: 10),
                                Text("N° " + index.toString()),
                                SizedBox(width: 10),
                                Container(
                                  width: 100,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("PIDs"),
                                            SizedBox(width: 10),
                                            Text(getresponse[index].pid),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Text("Titulo"),
                                            SizedBox(width: 10),
                                            Text(getresponse[index].title),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 95, // <-- Your width
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          )),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  const Color(0xFF26B07F)),
                                        ),
                                        child: const Text(
                                          'Editar',
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 12.0),
                                        ),
                                        onPressed: () {
                                          pid.text = getresponse[index].pid;
                                          length.text = getresponse[index]
                                              .lenght
                                              .toString();
                                          title.text = getresponse[index].title;
                                          description.text =
                                              getresponse[index].description;
                                          openedit(pid, length, title,
                                              description, index);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 95, // <-- Your width
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          )),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 176, 38, 38)),
                                        ),
                                        child: const Text(
                                          'Deletar',
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 12.0),
                                        ),
                                        onPressed: () {
                                          deletpid(index);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
