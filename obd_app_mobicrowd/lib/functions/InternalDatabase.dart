import 'dart:math';

import 'package:haversine_distance/haversine_distance.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../dataBaseClass/obdRawData.dart';
import '../dataBaseClass/vehiclesUser.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart' as path_prov;
import '../functions/repository.dart';

import '../dataBaseClass/confSimu.dart';
import 'math.dart';

class InternalDatabase {
  bool a = false;
  var insertEventInstance = InternalMath();
  late Box confapp;

  Future<void> init() async {
    Hive.registerAdapter(UserdataAdapter());
    Hive.registerAdapter(UserVehicleRawAdapter());
    Hive.registerAdapter(UserDataProcessAdapter());
    Hive.registerAdapter(UserAccAdapter());
    Hive.registerAdapter(PositionClassAdapter());
    Hive.registerAdapter(ObdRawDataAdapter());
    Hive.registerAdapter(ObdDataAdapter());
    Hive.registerAdapter(UserVehiclesAdapter());
    Hive.registerAdapter(ConfdataAdapter());
    Hive.registerAdapter(VinAdapter());

    confapp = await Hive.openBox<Confdata>('conf');
    if (confapp.length <= 0) {
      newvalue();
    }
  }

  void newvalue() async {
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
        on: false);

    var confapp = await Hive.openBox<Confdata>('conf');
    await confapp.add(a);
    await confapp.close();
  }

  bool isON() {
    if (Hive.isAdapterRegistered(2)) {
      return true;
      //<Userdata>('obdData')
    } else {
      return false;
    }
    /*
    try {} catch (E) {
      print(E);
    }
    return false;*/
  }

  bool teste() {
    print(!Hive.isAdapterRegistered(2));
    if (!Hive.isAdapterRegistered(2)) {
      return true;
      //<Userdata>('obdData')
    } else {
      return false;
    }
    /*
    try {} catch (E) {
      print(E);
    }
    return false;*/
  }

  void insertObdData(var data) async {
    var obdData = await Hive.openBox<Userdata>('obdData');
    obdData.add(data);
    obdData.close();
  }

  int ValidInfo(Userdata element) {
    try {
      var vin = element.uservehicle.vin;
      var time = element.uservehicle.userdata.time;
      double lat = element.uservehicle.userdata.pos.lat;
      double long1 = element.uservehicle.userdata.pos.long;
      var pressure = element.uservehicle.userdata.userdata
          .firstWhere((element) => element.pid == '01 2F')
          .obddata
          .response;
      var vs = element.uservehicle.userdata.userdata
          .firstWhere((element) => element.pid == '01 0D')
          .obddata
          .response;

      //var a9= element['obdData']['01 0C']['response'];

      return 1;
    } catch (e) {}
    return 0;
  }

  List<List> filterapply(List farrk) {
    List af1 = insertEventInstance.kalmanfilter(farrk);
    List af2 = insertEventInstance.apply_savitzky(farrk);

    return [af1, af2];
  }

  void getDataOff(Map map) async {
    var sp = map['data'];

    Hive.registerAdapter(UserdataAdapter());
    Hive.registerAdapter(UserVehicleRawAdapter());
    Hive.registerAdapter(UserDataProcessAdapter());
    Hive.registerAdapter(UserAccAdapter());
    Hive.registerAdapter(PositionClassAdapter());
    Hive.registerAdapter(ObdRawDataAdapter());
    Hive.registerAdapter(ObdDataAdapter());
    Hive.registerAdapter(UserVehiclesAdapter());
    Hive.registerAdapter(VinAdapter());

    Box obdData = await Hive.openBox<Userdata>('obdData', path: sp);

    var processados = obdData.values
        .where((element) => element.uservehicle.userdata.processada == false);
    var order = processados.toList()
      ..sort((a, b) {
        int nameComp = a.uservehicle.vin.compareTo(b.uservehicle.vin);
        if (nameComp == 0) {
          return a.uservehicle.userdata.time
              .compareTo(b.uservehicle.userdata.time); // '-' for descending
        }
        return nameComp;
      });

    String vin1 = '';

    DateTime time1 = DateTime.parse('2020-01-02 03:04:05');
    DateTime time2 = DateTime.parse('2020-01-02 03:04:05');

    double tacc = 0;
    List tarr = [0.0];
    List taccarr = [0.0];

    double kmacch = 0;
    List kmarrh = [0.0];
    List kmaccarrh = [0.0];

    double kmacce = 0;
    List kmarre = [0.0];
    List kmaccarre = [0.0];

    double kmaccv = 0;
    List kmarrv = [0.0];
    List kmaccarrv = [0.0];

    List farrk = [];

    List points = [];

    double lat1 = 0, lat2 = 0, long1 = 0, long2 = 0;
    final haversineDistance = HaversineDistance();
    var start = Location(0, 0);
    int i = 0;
    int p = 0;
    for (Userdata element in order) {
      p += ValidInfo(element);

      if (vin1 == '') {
        vin1 = element.uservehicle.vin;
        time1 = DateTime.parse(element.uservehicle.userdata.time.toString());
        lat1 = element.uservehicle.userdata.pos.lat;
        long1 = element.uservehicle.userdata.pos.long;
        start = Location(lat1, long1);

        //LatLong.add([lat1, long1]);
      }
      time2 = DateTime.parse(element.uservehicle.userdata.time.toString());

      lat2 = element.uservehicle.userdata.pos.lat;
      long2 = element.uservehicle.userdata.pos.long;

      var end = Location(lat2, long2);

      points.add([lat2, long2]);
      if (time2.difference(time1).inSeconds < 120) {
        //math timw
        if (time2 != time1) {
          var deltt = (time2.difference(time1).inSeconds);

          tacc += deltt.toDouble();
          tarr.add(deltt.toDouble());
          taccarr.add(tacc.toDouble());

          //math haversine
          var deltkmha = haversineDistance.haversine(start, end, Unit.KM);

          kmacch += deltkmha.toDouble();
          kmarrh.add(deltkmha.toDouble());
          kmaccarrh.add(kmacch.toDouble());

          //math euclidean
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
          //math obd

          try {
            deltkmobd = double.parse(element.uservehicle.userdata.userdata
                    .firstWhere((element) => element.pid == '01 0D')
                    .obddata
                    .response) *
                (deltt / 3600);
          } catch (e) {
            deltkmobd = -1.0;
          }
          kmarrv.add(deltkmobd.toDouble());

          try {
            double fuelhelp = double.parse(element.uservehicle.userdata.userdata
                .firstWhere((element) => element.pid == '01 2F')
                .obddata
                .response);
            farrk.add(fuelhelp);
          } catch (e) {
            farrk.add(-1.0);
          }

          time1 = time2;
          lat1 = element.uservehicle.userdata.pos.lat;
          long1 = element.uservehicle.userdata.pos.long;
          start = Location(lat1, long1);
        }
      }

      if ((vin1 != element.uservehicle.vin || element == order.last) ||
          time2.difference(time1).inSeconds > 600) {
        if (kmarrv.length > 1 && farrk.length > 1) {
          List linear = insertEventInstance.regressionLinear1(taccarr, kmarrv);

          kmarrv = linear[0];
          kmaccv = linear[1];
          kmaccarrv = linear[2];

          linear = insertEventInstance.regressionLinear1(taccarr, farrk);
          farrk = linear[0];

          List auxf = await filterapply(farrk);

          List fuelregressionk =
              insertEventInstance.regressionLinear2(taccarr, auxf[0]);
          List fuelregressions =
              insertEventInstance.regressionLinear2(taccarr, auxf[1]);

          var b = Vin(
              id: vin1,
              tarr: tarr,
              tacc: tacc,
              taccarr: taccarr,
              kmarrh: kmarrh,
              kmacch: kmacch,
              kmaccarrh: kmaccarrh,
              kmarre: kmarre,
              kmacce: kmacce,
              kmaccarre: kmaccarre,
              kmarrv: kmarrv,
              kmaccv: kmaccv,
              kmaccarrv: kmaccarrv,
              farrk: farrk,
              fuelk: fuelregressionk[0],
              fuels: fuelregressions[0],
              fuelkf: auxf[0],
              fuelsf: auxf[1],
              m: fuelregressionk[1],
              c: fuelregressionk[2],
              rquare: fuelregressionk[3],
              m2: fuelregressions[1],
              c2: fuelregressions[2],
              rquare2: fuelregressions[3],
              points: points,
              percentdata: p / order.length * 100);

          var userdataride = UserVehicles(user: element.name, vehicle: b);

          Box teste2 = await Hive.openBox<UserVehicles>('userdata', path: sp);

          await teste2.add(userdataride).then((value) {
            p = 0;

            vin1 = '';
            tarr.clear();
            tarr.add(0.0);
            tacc = 0;
            taccarr.clear();
            taccarr.add(0.0);

            kmarrh.clear();
            kmarrh.add(0.0);
            kmacch = 0;
            kmaccarrh.clear();
            kmaccarrh.add(0.0);
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
            lat1 = element.uservehicle.userdata.pos.lat;
            long1 = element.uservehicle.userdata.pos.long;
          });
          print('foi');
        }
      }
      order[i].uservehicle.userdata.processada = true;
      obdData.putAt(i, order[i]);
      i++;
    }
  }
}
