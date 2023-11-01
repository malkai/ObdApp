import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../autoroute/autoroute.gr.dart';
import '../dataBaseClass/confSimu.dart';
import '../functions/obdPlugin.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:auto_route/auto_route.dart';

class InitBluetooth extends StatefulWidget {
  InitBluetooth({
    Key? key,
  }) : super(key: key);

  @override
  State<InitBluetooth> createState() => _FloatState();
}

class _FloatState extends State<InitBluetooth> {
  bool aux = true;
  late Box confapp;
  late Confdata confdata;

  var obd2 = ObdPlugin();
  bool help = true;

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
  }

  OverlayEntry? entry;

  void init() async {
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

  Future<void> showBluetoothList(
      BuildContext context, ObdPlugin obd2plugin) async {
    List<BluetoothDevice> devices = await obd2plugin.getPairedDevices;

    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
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
                        obd2plugin.getConnection(devices[index], (connection) {
                          try {
                            change_flag();

                            context.router.popAndPush(Obddtarouter(
                                obd2: obd2,
                                turnOBD_OFF: turnOBD_OFF,
                                help: help));
                          } catch (e) {
                            print(e);
                          }
                        }, (message) {
                          print("error in connecting: $message");
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
            ));
  }

  @override
  Widget build(BuildContext context) {
    return aux
        ? Container(
            color: Colors.brown[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: FloatingActionButton(
                    child: const Icon(Icons.bluetooth),
                    onPressed: () async {
                      init();

                      List<BluetoothDevice> devices =
                          await obd2.getPairedDevices;
                      if (confdata.on == true) {
                        context.router.push(Obddtarouter(
                            obd2: obd2, turnOBD_OFF: turnOBD_OFF, help: help));
                      } else {
                        if (!(await obd2.isBluetoothEnable)) {
                          await obd2.enableBluetooth;
                        }
                        //_bluetooth.startDiscovery();
                        showBluetoothList(context, obd2);
                      }
                    },
                  ),
                )
              ],
            ),
          )
        : Container(
            color: Colors.brown[50],
          );
  }
}
