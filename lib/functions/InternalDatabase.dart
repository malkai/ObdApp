import 'dart:math';

import 'package:haversine_distance/haversine_distance.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/blockchain.dart';
import '../dataBaseClass/obdRawData.dart';
import '../dataBaseClass/vehiclesUser.dart';

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../dataBaseClass/confSimu.dart';
import 'math.dart';

class InternalDatabase {
  bool a = false;
  var insertEventInstance = InternalMath();
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
      print(process.length);
      blockchain connect = blockchain();

      //função responsavel por enviar dados;
      processingdataOBD(process.toList(), keys);

      //var bancoInterno = InternalDatabase();
      //bancoInterno.processingdataOBD(process, keys);
    }
  }

  void insertObdData(var data) async {
    var obdData = await Hive.openBox<Userdata>('obdData');
    if (obdData.containsKey(data) == false) {
      obdData.add(data);
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

  void processingdataOBD(var process, var keys) async {
    blockchain connect = blockchain();
    Box userdata = await Hive.openBox<wallet>('wallet');

    wallet user = userdata.getAt(0);

    String vin = '';
    DateTime time1 = DateTime.parse('2020-01-02 03:04:05');
    DateTime time2 = DateTime.parse('2020-01-02 03:04:05');

    var helplist = [];

    /*
   
    double tacc = 0;
    List tarr = [0.0];
    List taccarr = [0.0];

    double kmacce = 0;
    List kmarre = [0.0];
    List kmaccarre = [0.0];

    double kmaccv = 0;
    List kmarrv = [0.0];
    List kmaccarrv = [0.0];

    List farrk = [];

    List points = [];

    double lat1 = 0, lat2 = 0, long1 = 0, long2 = 0;

    var start = Location(0, 0);
    int i = 0;
    int p = 0;
    
    */
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
          if (await connect.checkconnection("www.google.com")) {
            print(await connect.checkconnection("www.google.com"));
            try {
              Response aux2 = await connect.sendata(helplist).timeout(
                const Duration(seconds: 5),
                onTimeout: () {
                  // Time has run out, do what you wanted to do.
                  return Response(
                      'Error', 408); // Request Timeout response status code
                },
              );

              if (helplist.length > 1 && aux2.statusCode == 200) {
                for (int aux = j_quebra; aux < i; aux++) {
                  //process[aux].uservehicle.userdata.processada = true;

                  //Box obdData = await Hive.openBox<Userdata>('obdData');

                  //await obdData.putAt(process[aux].key, process[aux]);
                }
              }
            } catch (e) {
              print("servidor de envio fora do ar");
            }
          }
        } else {
          for (int aux = j_quebra; aux < i; aux++) {
            //process[aux].uservehicle.userdata.processada = true;

            //Box obdData = await Hive.openBox<Userdata>('obdData');

            //await obdData.putAt(process[aux].key, process[aux]);
          }
        }

        j_quebra = i;

        helplist.clear();
      } else {
        helplist.add(process[i].uservehicle);
        vin = process[i].uservehicle.vin;
        //process[i].uservehicle.userdata.processada = true;

        //Box obdData = await Hive.openBox<Userdata>('obdData');

        //await obdData.putAt(process[i].key, process[i]);
      }
      /*
      p += validInfo(element);

      if (vin1 == '') {
        vin1 = element.uservehicle.vin;
        time1 = DateTime.parse(element.uservehicle.userdata.time.toString());
        lat1 = element.uservehicle.userdata.pos!.lat;
        long1 = element.uservehicle.userdata.pos!.long;
        start = Location(lat1, long1);

        //LatLong.add([lat1, long1]);
      }
      time1 = time2;
      time2 = DateTime.parse(element.uservehicle.userdata.time.toString());

      lat2 = element.uservehicle.userdata.pos!.lat;
      long2 = element.uservehicle.userdata.pos!.long;

      var end = Location(lat2, long2);

      points.add([lat2, long2]);
      if (time2.difference(time1).inSeconds < 1000) {
        if (time2 != time1) {
          //math total time
          var deltt = (time2.difference(time1).inSeconds);

          tacc += deltt.toDouble();
          tarr.add(deltt.toDouble());
          taccarr.add(tacc.toDouble());

          //math Eucledean
          int R = 6371;
          var x1 = R * cos(start.latitude) * cos(start.longitude);
          var y1 = R * cos(start.latitude) * sin(start.longitude);
          var z1 = R * sin(start.latitude);

          var x2 = R * cos(end.latitude) * cos(end.longitude);
          var y2 = R * cos(end.latitude) * sin(end.longitude);
          var z2 = R * sin(end.latitude);

          var deltkmeu =
              sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2) + pow(z2 - z1, 2));

          kmacce += deltkmeu.toDouble();
          kmarre.add(deltkmeu.toDouble());
          kmaccarre.add(kmacce.toDouble());
          var deltkmobd = 0.0;

          //math VS obd
          try {
            deltkmobd = double.parse(element.uservehicle.userdata.userdata!
                    .firstWhere((element) => element.pid == '01 0D')
                    .obddata
                    .response) *
                (deltt / 3600);
          } catch (e) {
            deltkmobd = 0.0;
          }
          kmarrv.add(deltkmobd.toDouble());
          kmaccv = kmaccv + deltkmobd;
          kmaccarrv.add(kmaccv);
          try {
            double fuelhelp = double.parse(element
                .uservehicle.userdata.userdata!
                .firstWhere((element) => element.pid == '01 2F')
                .obddata
                .response);
            farrk.add(fuelhelp);
          } catch (e) {
            farrk.add(-1.0);
          }

          time1 = time2;
          lat1 = element.uservehicle.userdata.pos!.lat;
          long1 = element.uservehicle.userdata.pos!.long;
          start = Location(lat1, long1);
        }
      }
      if (vin1 != element.uservehicle.vin || element == process.last) {
        if (kmarrv.length > 1 && farrk.length > 1) {
          List auxf = insertEventInstance.kalmanfilter(farrk);

          var b = Vin(
              id: vin1,
              tarr: tarr,
              tacc: tacc,
              taccarr: taccarr,
              kmarre: kmarre,
              kmacce: kmacce,
              kmaccarre: kmaccarre,
              kmarrv: kmarrv,
              kmaccv: kmaccv,
              kmaccarrv: kmaccarrv,
              farrk: farrk,
              fuelkf: auxf,
              points: points,
              percentdata: p / process.length * 100);

          var userdataride = UserVehicles(user: element.name, vehicle: b);

          Box teste2 = await Hive.openBox<UserVehicles>('userdata');
          if (teste2.containsKey(userdataride) == false) {
            teste2.add(userdataride).then((value) {
              p = 0;
              vin1 = '';
              tarr.clear();
              tarr.add(0.0);
              tacc = 0;
              taccarr.clear();
              taccarr.add(0.0);
              kmarre.clear();
              kmarre.add(0.0);
              kmacce = 0;
              kmaccarre.clear();
              kmaccarre.add(0.0);
              kmarrv.clear();
              kmarrv.add(0.0);
              kmaccv = 0;
              kmaccarrv.clear();
              kmaccarrv.add(0.0);
              farrk.clear();
              farrk.add(0.0);
              lat1 = element.uservehicle.userdata.pos!.lat;
              long1 = element.uservehicle.userdata.pos!.long;
            });
            await teste2.close();
          }
        }
        */

      //print(process[i].uservehicle.userdata.processada);

      //if (i <= process.length - 1) {
      //  i++;
      //}
    }
  }
}
