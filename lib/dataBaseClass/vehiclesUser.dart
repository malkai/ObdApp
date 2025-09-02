import 'package:hive/hive.dart';

part 'vehiclesUser.g.dart';

@HiveType(typeId: 0)
class UserVehicles {
  @HiveField(0)
  String user;
  @HiveField(1)
  Path vehicle;
  UserVehicles({
    required this.user,
    required this.vehicle,
  });
}


@HiveType(typeId: 1)
class Path {
  @HiveField(0)
  String id;

  //time
  @HiveField(1)
  double tacc;

  //distance_eucle
  @HiveField(2)
  List kmarre;

  //regressão linear lista
  @HiveField(3)
  List farrk;

  //inicio final do consuno
  @HiveField(4)
  List fuelkf;

  //dados aprovados
  @HiveField(5)
  double percentdata;

  //data do evento
  @HiveField(6)
  DateTime time = DateTime.now();

  //data do evento lat and long
  @HiveField(7)
  List points = [];

  Path({
    required this.id,
    required this.tacc,
    required this.kmarre,
    required this.farrk,
    required this.percentdata,
    required this.fuelkf,
    required this.points,
  });
}
