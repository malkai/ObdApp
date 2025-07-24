import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../dataBaseClass/confSimu.dart';
import '../dataBaseClass/pidDiscoveryClass.dart';
import '../functions/obdPlugin.dart';
import '../route/autoroute.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class InitBluetooth extends StatefulWidget {
  const InitBluetooth({
    super.key,
  });

  @override
  State<InitBluetooth> createState() => _FloatState();
}

class _FloatState extends State<InitBluetooth> {
  bool aux = true;
  late Box confapp;
  late Confdata confdata;

  var obd2 = ObdPlugin();
  bool help = true;
  var pid = TextEditingController(text: '');
  var length = TextEditingController(text: '');
  var title = TextEditingController(text: '');
  var description = TextEditingController(text: '');
  Box? pidDisc;

  List<dynamic> getresponse = [];

  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  change_flag() {
    setState(() {
      help = !help;
    });
  }

  void turnOBD_OFF() async {
    setState(() {
      obd2.connection?.close();
      obd2.connection?.finish();
      obd2.connection?.dispose();
      obd2.disconnect();
    });
    obd2 = ObdPlugin();
  }

  OverlayEntry? entry;

  void init() async {
    pidDisc = await Hive.openBox<pidsDisc>('pidsDisc');

    setState(() {
      getresponse = pidDisc!.values.toList();
    });
    confapp = await Hive.openBox<Confdata>('conf');
    confdata = confapp.getAt(0);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  Future<void> insetpid(int index) async {
    var element = pidsDisc(pid: pid.text, title: title.text);
    element.unit = length.text;
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
        content: SizedBox(
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
                  labelText: 'unit',
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

  Future<void> showBluetoothList(
      BuildContext context, ObdPlugin obd2plugin) async {
    List<BluetoothDevice> devices = await obd2plugin.getPairedDevices;

    showBottomSheet(
        context: context,
        builder: (BuildContext context) => TapRegion(
            onTapOutside: (tap) {
              context.router.popUntilRouteWithName(Appmain.name);
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
                          // if (!conn2) {

                          change_flag();
                          int indexr = 0;
                          int count = 0;

                          for (int i = 0; i < getresponse.length; i++) {
                            if (getresponse[i].ativo) {
                              count++;
                              indexr = i;
                            }
                          }
                          if (count == 0 && confdata.on == false) {
                            showerror("Selecione um PID");
                          }
                          if (count > 1 && confdata.on == false) {
                            showerror("Só pode ser enviado um comando por vez");
                          } else {
                            context.router
                                .popAndPush(Obddata(obd2: obd2, value: indexr));
                          }
                          //}
                        }, (message) {
                          showerror("Não é possível conectar-se");
                        });

                        //Navigator.pop(context, aux);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btninit2",
            backgroundColor: Color(0xFF26B07F),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              openedit(pid, length, title, description, -1);
            },
          ),
          SizedBox(height: 30),
          FloatingActionButton(
            heroTag: "btninit",
            backgroundColor: Color(0xFF26B07F),
            child: const Icon(
              Icons.bluetooth_searching,
              color: Colors.white,
            ),
            onPressed: () async {
              init();
              int indexr = 0;
              int count = 0;

              for (int i = 0; i < getresponse.length; i++) {
                if (getresponse[i].ativo) {
                  count++;
                  indexr = i;
                }
              }
              if (count == 0 && confdata.on == false) {
                showerror("Selecione um PID");
              }
              if (count > 1 && confdata.on == false) {
                showerror("Só pode ser enviado um comando por vez");
              } else if (count == 1 || confdata.on) {
                if (confdata.on || !confdata.obd) {
                  context.router.push(Obddata(obd2: obd2, value: indexr));
                } else {
                  if (!(await obd2.isBluetoothEnable)) {
                    await obd2.enableBluetooth;
                  }
                  turnOBD_OFF();

                  showBluetoothList(context, obd2);
                  //obd2 = ObdPlugin();
                }
              }
            },
          )
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
                              Text("N° $index"),
                              SizedBox(width: 10),
                              SizedBox(
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
                                        length.text = getresponse[index].unit;
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
    );
  }
}
