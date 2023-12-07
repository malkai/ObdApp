import 'package:hive/hive.dart';

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



  //distance_eucle

  @HiveField(4)
  List kmarre;
  @HiveField(5)
  double kmacce;
  @HiveField(6)
  List kmaccarre;

  //distance_vs

  @HiveField(7)
  List kmarrv;
  @HiveField(8)
  double kmaccv;
  @HiveField(9)
  List kmaccarrv;

  //Kalmanfilter AND savitzky_golay

  @HiveField(10)
  List farrk;

  @HiveField(11)
  List fuelkf;

  //fuelsf: auxf[1],

  @HiveField(12)
  double percentdata;

  @HiveField(13)
  DateTime time = DateTime.now();

  @HiveField(14)
  List points = [];

  Vin({
    required this.id,
    required this.tarr,
    required this.tacc,
    required this.taccarr,
    required this.kmarre,
    required this.kmacce,
    required this.kmaccarre,
    required this.kmarrv,
    required this.kmaccv,
    required this.kmaccarrv,
    required this.farrk,
    required this.percentdata,
    required this.fuelkf,
    required this.points,
  });
}
