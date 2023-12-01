import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

part 'vehiclesUser.g.dart';

@HiveType(typeId: 0)
class UserVehicles {
  @HiveField(0)
  String user;
  @HiveField(1)
  Vin vehicle;
  UserVehicles({
    required this.user,
    required this.vehicle,
  });
}

@HiveType(typeId: 1)
class Vin {
  @HiveField(0)
  String id;

  //time

  @HiveField(1)
  List tarr;
  @HiveField(2)
  double tacc;
  @HiveField(3)
  List taccarr;

  //distance_harv

  @HiveField(4)
  List kmarrh;
  @HiveField(5)
  double kmacch;
  @HiveField(6)
  List kmaccarrh;

  //distance_eucle

  @HiveField(7)
  List kmarre;
  @HiveField(8)
  double kmacce;
  @HiveField(9)
  List kmaccarre;

  //distance_vs

  @HiveField(10)
  List kmarrv;
  @HiveField(11)
  double kmaccv;
  @HiveField(12)
  List kmaccarrv;

  //Kalmanfilter AND savitzky_golay

  @HiveField(13)
  List farrk;

  @HiveField(14)
  double m;
  @HiveField(15)
  double c;
  @HiveField(16)
  double rquare;
  @HiveField(17)
  double m2;
  @HiveField(18)
  double c2;
  @HiveField(19)
  double rquare2;

  @HiveField(20)
  List fuelk;
  @HiveField(21)
  List fuels;
  @HiveField(22)
  List fuelkf;
  @HiveField(23)
  List fuelsf;

  @HiveField(24)
  double percentdata;

  @HiveField(25)
  DateTime time = DateTime.now();

  @HiveField(26)
  List points = [];

  Vin({
    required this.id,
    required this.tarr,
    required this.tacc,
    required this.taccarr,
    required this.kmarrh,
    required this.kmacch,
    required this.kmaccarrh,
    required this.kmarre,
    required this.kmacce,
    required this.kmaccarre,
    required this.kmarrv,
    required this.kmaccv,
    required this.kmaccarrv,
    required this.farrk,
    required this.m,
    required this.c,
    required this.rquare,
    required this.m2,
    required this.c2,
    required this.rquare2,
    required this.fuelk,
    required this.fuels,
    required this.percentdata,
    required this.fuelkf,
    required this.fuelsf,
    required this.points,
  });
}
