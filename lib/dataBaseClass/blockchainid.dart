import 'package:hive/hive.dart';

import 'vehiclesUser.dart';

part 'blockchainid.g.dart';

//classe criada exclusivamente para contratos inteligentes
@HiveType(typeId: 12)
class Contract {
  @HiveField(0)
  String add;
  @HiveField(1)
  DateTime time;
  @HiveField(2)
  String status;
  @HiveField(3)
  List<Path> vehicle;
  Contract(
      {required this.add,
      required this.vehicle,
      required this.time,
      required this.status});
}

//classe criada exclusivamente para contratos inteligentes
@HiveType(typeId: 13)
class wallet {
  @HiveField(0)
  String add;
  @HiveField(1)
  String site = "";
  @HiveField(2)
  String name;
  @HiveField(3)
  bool blockchain = false;
  @HiveField(4)
  String vin = "";
  @HiveField(5)
  String usertank = "";

  wallet({required this.add, required this.name});
}

@HiveType(typeId: 14)
class Event {
  @HiveField(0)
  int id;
  @HiveField(1)
  String add;
  @HiveField(2)
  String vin;
  @HiveField(3)
  String fuel_B;
  @HiveField(4)
  String fuel_E;
  @HiveField(5)
  String usertank;
  @HiveField(6)
  String abastecimento;
  @HiveField(7)
  DateTime date;
  @HiveField(8)
  bool status = false;
  @HiveField(9)
  List<PathBlockchain> paths = [];
  @HiveField(10)
  String value = " ";

  Event({
    required this.id,
    required this.add,
    required this.vin,
    required this.fuel_B,
    required this.fuel_E,
    required this.usertank,
    required this.abastecimento,
    required this.date,
  });
}

@HiveType(typeId: 15)
class PathBlockchain {
  @HiveField(0)
  String dist;
  @HiveField(1)
  String fuel;
  @HiveField(2)
  String time;
  @HiveField(3)
  String timeless;
  @HiveField(5)
  List arrlatlong=[];

  PathBlockchain(
      {required this.dist,
      required this.fuel,
      required this.time,
      required this.timeless});
}

@HiveType(typeId: 16)
class UserScore {
  @HiveField(0)
  String comp;
  @HiveField(1)
  String freq;
  @HiveField(2)
  String conf;
  UserScore({
    required this.comp,
    required this.freq,
    required this.conf,
  });
}
