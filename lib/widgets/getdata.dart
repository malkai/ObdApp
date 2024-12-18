import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../dataBaseClass/confSimu.dart';
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
                        obd2plugin.getConnection(devices[index], (connection) {
                          try {
                            change_flag();
                            context.router.popAndPush(Obddata(obd2: obd2));
                          } catch (e) {
                            print(e);
                          }
                        }, (message) {});

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
    return aux
        ? Scaffold(
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
                  onPressed: () async {},
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

                    if (confdata.on == true) {
                      context.router.push(Obddata(obd2: obd2));
                    } else {
                      if (!(await obd2.isBluetoothEnable)) {
                        await obd2.enableBluetooth;
                      }
                      //_bluetooth.startDiscovery();

                      showBluetoothList(context, obd2);
                    }
                  },
                )
              ],
            ),
            body: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          )
        : Container(
            color: const Color.fromARGB(255, 255, 255, 255),
          );
  }
}
