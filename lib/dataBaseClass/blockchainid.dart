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

  wallet({required this.add, required this.name});
}

@HiveType(typeId: 14)
class Event {
  @HiveField(0)
  String evento;
  @HiveField(1)
  String data;
  @HiveField(2)
  List<Path> paths = [];

  Event({required this.evento, required this.data});
}

@HiveType(typeId: 15)
class PathBlockchain {
  @HiveField(0)
  String dist;
  @HiveField(1)
  String comb;
  @HiveField(2)
  String date;
  @HiveField(3)
  String timeless;

  PathBlockchain({required this.dist, required this.comb, required this.date, required this.timeless });
}
