import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/blockchain.dart';
import 'package:http/http.dart';

import '../dataBaseClass/obdRawData.dart';
import '../dataBaseClass/confSimu.dart';

class InternalDatabase {
  bool a = false;
  late Box confapp;
  late Box walletapp;

  void init() async {
    confapp = await Hive.openBox<Confdata>('conf');
    if (confapp.length <= 0) {
      var defult = Confdata(
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

      await confapp.add(defult);
    }

    walletapp = await Hive.openBox<wallet>('wallet');
    if (walletapp.length <= 0) {
      var defult = wallet(add: "0", name: "");
      await walletapp.add(defult);
    }
  }

  Future<void> handledata() async {
    List<int> keys = [];
    Box<Userdata> obdData = await Hive.openBox<Userdata>('obdData');
    var process = obdData.values
        .where((element) => element.uservehicle.userdata.processada == false);
    for (var element in process) {
      keys.add(element.key);
    }

    if (process.isNotEmpty) {
      blockchain connect = blockchain();

      processingdataOBD(process.toList(), keys);
    }
  }

  void insertObdData(Userdata data) async {
    var obdData = await Hive.openBox<Userdata>('obdData');
    if (data.uservehicle.userdata.pos?.lat != 0.0 &&
        data.uservehicle.userdata.pos?.long != 0.0) {
      if (obdData.containsKey(data) == false) {
        obdData.add(data);
      }
    }
  }

  int validInfo(Userdata element) {
    try {
      var vin = element.uservehicle.vin;
      var time = element.uservehicle.userdata.time;
      double lat = element.uservehicle.userdata.pos!.lat;
      double long1 = element.uservehicle.userdata.pos!.long;
      var pressure = element.uservehicle.userdata.userdata!
          .firstWhere((element) => element.pid == '01 2F')
          .obddata
          .response;
      var vs = element.uservehicle.userdata.userdata!
          .firstWhere((element) => element.pid == '01 0D')
          .obddata
          .response;

      //var a9= element['obdData']['01 0C']['response'];

      return 1;
    } catch (e) {}
    return 0;
  }

  void processingdataOBD(List<Userdata> process, var keys) async {
    blockchain auxblock = blockchain();
    Box userdata = await Hive.openBox<wallet>('wallet');

    wallet user = userdata.getAt(0);

    String vin = '';
    DateTime time1 = DateTime.parse('2020-01-02 03:04:05');
    DateTime time2 = DateTime.parse('2020-01-02 03:04:05');

    List<dynamic> helplist = [];

    int j_quebra = 0;
    for (int i = 0; i < process.length; i++) {
      if (vin == '') {
        vin = process[i].uservehicle.vin;
      }
      time1 = DateTime.parse(process[i].uservehicle.userdata.time.toString());
      if (i < process.length - 1) {
        time2 =
            DateTime.parse(process[i + 1].uservehicle.userdata.time.toString());
      }

      if (vin != process[i].uservehicle.vin ||
          time2.difference(time1).inSeconds > 60 ||
          i == process.length - 1) {
        if (user.blockchain) {
          if (await auxblock.checkServerStatus(user.site + "/jwtserver/")) {
            try {
              print("envia");
              if (helplist.length > 1) {
                Response aux2 = await auxblock.sendata(helplist).timeout(
                  const Duration(seconds: 5),
                  onTimeout: () {
                    // Time has run out, do what you wanted to do.
                    return Response(
                        'Error', 408); // Request Timeout response status code
                  },
                );
              }

              for (int aux = j_quebra; aux < i; aux++) {
                process[aux].uservehicle.userdata.processada = true;

                Box obdData = await Hive.openBox<Userdata>('obdData');

                await obdData.putAt(process[aux].key, process[aux]);
              }
            } catch (e) {
              print(e);
              print("servidor de envio fora do ar");
            }
          }
        } else {
          for (int aux = j_quebra; aux < i; aux++) {
            process[aux].uservehicle.userdata.processada = true;

            Box obdData = await Hive.openBox<Userdata>('obdData');

            await obdData.putAt(process[aux].key, process[aux]);
          }
        }

        j_quebra = i;

        helplist.clear();
      }
      helplist.add(process[i].toJson());
    }
  }
}
