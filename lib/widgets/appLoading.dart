import 'dart:isolate';
import 'package:hive_flutter/hive_flutter.dart';
import '../autoroute/autoroute.gr.dart';
import '../dataBaseClass/obdRawData.dart';
import 'package:path_provider/path_provider.dart' as path_prov;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../dataBaseClass/vehiclesUser.dart';
import '../functions/internalDatabase.dart';

class AppLoading extends StatefulWidget {
  final String text;
  AppLoading({Key? key, this.text = ''}) : super(key: key);

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {
  void init() async {
    bool firstime;

    var bancoInterno = InternalDatabase();
    firstime = bancoInterno.teste();
    /*
    final diretorioUsuario = await path_prov.getApplicationDocumentsDirectory();
    ReceivePort receivePort = ReceivePort();
    Map map = {
      "sendPort": receivePort.sendPort,
      "data": diretorioUsuario.path.toString(),
    };
    bancoInterno.getDataOff(map);

    Future<List> processdata() async {
    List help = [];
    var bancoInterno = InternalDatabase();
    ReceivePort receivePort = ReceivePort();
    Map map = {
      "sendPort": receivePort.sendPort,
      "listContacts": help,
    };
    await Isolate.spawn(bancoInterno.getDataOff, map);

    help = await receivePort.first;
    return help;
  }

  static void _calculate(Map map) {
    var sp = map['sendPort'];
    for (int i = 0; i < 10; i++) {
      map['listContacts'].add(i);
    }
    //print(map['listContacts']);
    sp.send(map['listContacts']);
  }
    */

    if (!firstime) {
      handledata();
      setState(() {});
      context.router.replace(Initialrouter());
    } else {
      await bancoInterno.init();
      handledata();
      setState(() {});
      context.router.replace(Initialrouter());
    }
    //
  }

  Future<void> handledata() async {
    Box obdData = await Hive.openBox<Userdata>('obdData');

    var process = obdData.values
        .where((element) => element.uservehicle.userdata.processada == false);

    if (process.isNotEmpty) {
      final diretorioUsuario =
          await path_prov.getApplicationDocumentsDirectory();
      //sendData(diretorioUsuario.path);
      var bancoInterno = InternalDatabase();
      Map map = {
        "data": diretorioUsuario,
      };
      bancoInterno.getDataOff(map);
    }
  }

  Future<int> verify() async {
    Box box = await Hive.openBox<UserVehicles>('uservehicledata');
    var help =
        box.values.where((user) => user.uservehicle.userdata.isOnline == false);
    return help.length;
  }

  void sendData(var path) async {
    //var processados
    var bancoInterno = InternalDatabase();
    ReceivePort receivePort = ReceivePort();
    Map map = {
      "sendPort": receivePort.sendPort,
      "data": path,
    };
    await Isolate.spawn(bancoInterno.getDataOff, map);
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(children: [
          const LinearProgressIndicator(
            color: Colors.indigo,
          ),
          Text(
            widget.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          )
        ]),
      ),
    );
  }
}


/*


class Apploading extends StatelessWidget {
  final String text;

  const Apploading({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Center(
        child: Column(children: [
          LinearProgressIndicator(
            color: Colors.indigo,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          )
        ]),
      )),
    );
  }
}
*/