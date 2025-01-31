import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obdapp/dataBaseClass/confSimu.dart';
import 'package:obdapp/dataBaseClass/obdRawData.dart';
import 'package:obdapp/functions/InternalDatabase.dart';
import 'package:obdapp/functions/obdPlugin.dart';
import 'package:obdapp/route/autoroute.dart';
import 'package:obdapp/widgets/textWidget.dart';
import 'package:path_provider/path_provider.dart' as path_prov;

import '../dataBaseClass/pidDiscoveryClass.dart';

@RoutePage()
class getallpids extends StatefulWidget {
  const getallpids({super.key});

  @override
  State<getallpids> createState() => _getallpidsState();
}

class _getallpidsState extends State<getallpids> {
  Box? confapp;
  Confdata? confdata;
  Timer? _timer;
  var bancoInterno = InternalDatabase();
  List data = [];
  Box? pidAvaliable;
  List<ObdRawData> responses = [];

  var obd2 = ObdPlugin();
  String pidAll = 'Buscar';

  void turnOBD_OFF() async {
    setState(() {
      obd2.connection?.close();
      obd2.connection?.finish();
      obd2.connection?.dispose();
      obd2.disconnect();
    });
    obd2 = ObdPlugin();
  }

  List pid01 = [
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
    "20"
  ];
  List pid01r = [];

  List pid20 = [
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
    "40"
  ];
  List pid20r = [];

  List pid40 = [
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
    "60"
  ];
  List pid40r = [];

  List pid60 = [
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
    "80"
  ];
  List pid60r = [];

  List pid80 = [
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
    "A0"
  ];
  List pid80r = [];

  List pidA0 = [
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
  List pidA0r = [];
  late BluetoothDevice help;

  Future<void> insetpid(var resp) async {
    pidAvaliable = await Hive.openBox<ObdRawData>('codesAva');

    if (pidAvaliable!.isEmpty) {
      for (int i = 0; i < resp.length; i++) {
        pidAvaliable!.add(resp[i]);
      }
    } else {
      if (pidAvaliable!.isNotEmpty) {
        for (int i = 0; i < resp.length; i++) {
          pidAvaliable!.putAt(i, resp[i]);
        }
      }
    }

    await pidAvaliable?.close();
  }

  Future<void> checkpis(var ui) async {
    String jsonString = json.encode([ui]);

    if (obd2.connection?.isConnected != false &&
        obd2.connection?.isConnected != null) {
      await Future.delayed(
          Duration(milliseconds: await obd2.getParamsFromJSON(jsonString)),
          () {print("done");});
    }
  }

  @pragma('vm:entry-point')
  void obdinfo() async {
    if (!(await obd2.isListenToDataInitialed)) {
      obd2.setOnDataReceived((command, response, requestCode) async {
        print(response);
        List resps = jsonDecode(response);

        if (resps.isNotEmpty) {
          for (var reading in resps) {
            if (reading['PID'] == "01 00") {
              pid01r.clear();
            } else if (reading['PID'] == "01 20") {
              pid20r.clear();
            } else if (reading['PID'] == "01 40") {
              pid40r.clear();
            } else if (reading['PID'] == "01 60") {
              pid60r.clear();
            } else if (reading['PID'] == "01 80") {
              pid80r.clear();
            } else if (reading['PID'] == "01 A0") {
              pidA0r.clear();
            }

            String a = reading['response'];
            if (a.length == 23) {
              a = a.substring(11, 22);
              for (int i = 0; i < a.length; i++) {
                if (a[i] != " ") {
                  var help1 = int.parse(a[i], radix: 16).toRadixString(2);

                  var value = "true";

                  for (int j = 0; j < help1.length; j++) {
                    if (help1[j] == "0") {
                      value = "false";
                    } else {
                      value = "true";
                    }
                    if (reading['PID'] == "01 00") {
                      pid01r.add(value);
                    } else if (reading['PID'] == "01 20") {
                      pid20r.add(value);
                    } else if (reading['PID'] == "01 40") {
                      pid40r.add(value);
                    } else if (reading['PID'] == "01 60") {
                      pid60r.add(value);
                    } else if (reading['PID'] == "01 80") {
                      pid80r.add(value);
                    } else if (reading['PID'] == "01 A0") {
                      pidA0r.add(value);
                    }
                  }
                }
              }
            } else {
              if (reading['PID'] == "01 00") {
                a.replaceAll('01 00', '');
              } else if (reading['PID'] == "01 20") {
                a.replaceAll('01 20', '');
              } else if (reading['PID'] == "01 40") {
                a.replaceAll('01 40', '');
              } else if (reading['PID'] == "01 60") {
                a.replaceAll('01 60', '');
              } else if (reading['PID'] == "01 80") {
                a.replaceAll('01 80', '');
              } else if (reading['PID'] == "01 A0") {
                a.replaceAll('01 A0', '');
              }
            }

            print(a);
            ObdData help2 = ObdData(
                unit: reading['unit'], title: reading['title'], response: a);
            ObdRawData help1 = ObdRawData(pid: reading['PID'], obddata: help2);

            if (reading['PID'] == "01 00") {
              help2.codes = pid01;
              help2.codesvalues = pid01r;
            } else if (reading['PID'] == "01 20") {
              help2.codes = pid20;
              help2.codesvalues = pid20r;
            } else if (reading['PID'] == "01 40") {
              help2.codes = pid40;
              help2.codesvalues = pid40r;
            } else if (reading['PID'] == "01 60") {
              help2.codes = pid60;
              help2.codesvalues = pid60r;
            } else if (reading['PID'] == "01 80") {
              help2.codes = pid80;
              help2.codesvalues = pid80r;
            } else if (reading['PID'] == "01 A0") {
              help2.codes = pidA0;
              help2.codesvalues = pidA0r;
            }

            responses.add(help1);
          }
        }

        print(responses.length);
        setState(() {
          responses;
        });
      });

      /*

      if (await obd2.hasConnection) {
        setState(() {
          obd2.connection?.close();
          obd2.connection?.finish();
          obd2.connection?.dispose();
          obd2.disconnect();
        });
        obd2 = ObdPlugin();
      }
      */
      //print("oi2");
      // await checkpis(requeridResponse[0]);
      //for (var ui in requeridResponse) {
      //  print("oi1");
      //}
      var requeridResponse = [
        {
          "PID": "01 00",
          "length": 4,
          "title": "PIDs supported [01 - 20]",
          "unit": "",
          "description": "<bit>",
          "status": true
        },
        {
          "PID": "01 20",
          "length": 4,
          "title": "PIDs supported [21 - 40]",
          "unit": "",
          "description": "<bit>",
          "status": true
        },
        {
          "PID": "01 40",
          "length": 4,
          "title": "PIDs supported [41 - 60]",
          "unit": "",
          "description": "<bit>",
          "status": true
        },
        {
          "PID": "01 60",
          "length": 4,
          "title": "PIDs supported [61 - 80]",
          "unit": "",
          "description": "<bit>",
          "status": true
        },
        {
          "PID": "01 80",
          "length": 4,
          "title": "PIDs supported [81  - A0]",
          "unit": "",
          "description": "<bit>",
          "status": true
        },
        {
          "PID": "01 A0",
          "length": 4,
          "title": "PIDs supported [A1  - C0]",
          "unit": "",
          "description": "<bit>",
          "status": true
        },
      ];

      for (var i in requeridResponse) {
        await checkpis(i);
        await Future.delayed(Duration(seconds: 10));
      }

/*
      int j = 1;

      int count = 0;



      for (var i in requeridResponse) {
        

        while (responses.length < j) {
          await Future.delayed(
            Duration(seconds: 5),
          );
          count += 5;
          print(count);
        }
        print("oi");
        responses[j - 1].timer = count;
        j++;
        count = 0;
      }

*/
      insetpid(responses);

      setState(() {
        responses;
      });
    }
  }

  Future<void> showBluetoothList(
    BuildContext context,
    ObdPlugin obd2plugin,
  ) async {
    List<BluetoothDevice> devices = await obd2plugin.getPairedDevices;

    showBottomSheet(
        context: context,
        builder: (BuildContext context) => TapRegion(
            onTapOutside: (tap) {
              getpids();
              context.router.popUntilRouteWithName(Pidsdiscovery.name);
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 0),
              width: double.infinity,
              height: devices.length * 50,
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        obd2plugin.getConnection(devices[index],
                            (connection) async {
                          print("connected to bluetooth device.");
                          try {
                            context.router
                                .popUntilRouteWithName(Pidsdiscovery.name);
                            getinfo();
                          } catch (e) {
                            print(e);
                          }
                        }, (message) {
                          print("error in connecting: $message");
                        });
                      },
                      child: Center(
                        child: Text(devices[index].name.toString()),
                      ),
                    ),
                  );
                },
              ),
            )));
  }

  void getinfo() async {
    final diretorioUsuario = await path_prov.getApplicationDocumentsDirectory();

    File file =
        File(diretorioUsuario.path + "/" + DateTime.now().toString() + '.json');
    String terre = "${diretorioUsuario.path}/${DateTime.now()}";
    file.create();
    int ui = 0;

    obdinfo();

    ui++;
  }

  Future<void> getpids() async {
    pid01r.clear();
    pid20r.clear();
    pid40r.clear();
    pid60r.clear();
    pid80r.clear();
    pidA0r.clear();
    responses.clear();
    pidAvaliable = await Hive.openBox<ObdRawData>('codesAva');
    print(pidAvaliable!.values.length);
    if (pidAvaliable!.values.isNotEmpty) {
      responses = pidAvaliable!.values.toList().cast<ObdRawData>();
    }
    setState(() {
      responses;
    });
  }

  Future<void> init() async {
    confapp = await Hive.openBox<Confdata>('conf');
    await getpids();
    if (confapp == null) {
      var bancoInterno = InternalDatabase();
      bancoInterno.init();

      var a = Confdata(
          rpmmin: 750,
          rpmmax: 10000,
          velomin: 0,
          velomax: 120,
          templamin: 90,
          templamax: 104.4,
          pressmin: 14.7,
          pressmax: 101,
          vin: '1GBJC34R9XF017297',
          tempaemin: 30,
          tempaemax: 70,
          mafmin: 400,
          mafmax: 1000,
          percentmin: 50,
          percentmax: 70,
          responseobddata: [],
          name: 'Appteste',
          timereqobd: '1',
          on: false);
      confdata = a;
    } else {
      confdata = confapp!.getAt(0);
      setState(() {
        confdata;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
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
              heroTag: "btn1",
              child: const Icon(
                Icons.construction,
                color: Colors.white,
              ),
              onPressed: () async {
                if (!(await obd2.isBluetoothEnable)) {
                  await obd2.enableBluetooth;
                }

                turnOBD_OFF();

                setState(() {
                  pid01r.clear();
                  pid20r.clear();
                  pid40r.clear();
                  pid60r.clear();
                  pid80r.clear();
                  pidA0r.clear();
                  responses.clear();
                });
                await showBluetoothList(context, obd2);

                //_bluetooth.startDiscovery();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: responses.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(" " + responses[index].obddata.title),
                          SizedBox(width: 10),
                        ],
                      ),
                      if (responses[index].obddata.codesvalues.isNotEmpty)
                        SelectionArea(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    responses[index].obddata.codesvalues.length,
                                itemBuilder: (context, k) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            responses[index].obddata.codes[k],
                                            style: TextStyle(
                                              color: (responses[index]
                                                          .obddata
                                                          .codesvalues[k] ==
                                                      "false")
                                                  ? const Color.fromARGB(
                                                      255, 132, 132, 132)
                                                  : const Color.fromARGB(
                                                      255, 99, 211, 135),
                                            ),
                                          ),
                                          Text(
                                            responses[index]
                                                .obddata
                                                .codesvalues[k],
                                            style: TextStyle(
                                              color: (responses[index]
                                                          .obddata
                                                          .codesvalues[k] ==
                                                      "false")
                                                  ? const Color.fromARGB(
                                                      255, 132, 132, 132)
                                                  : const Color.fromARGB(
                                                      255, 99, 211, 135),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              " " + responses[index].obddata.response,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
