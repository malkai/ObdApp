import 'package:hive_flutter/hive_flutter.dart';

part 'pidDiscoveryClass.g.dart';

@HiveType(typeId: 11)
class pidsDisc {
  //750 - 10.000
  @HiveField(0)
  String pid;
  @HiveField(1)
  String title;
  @HiveField(2)
  int lenght = 1;
  @HiveField(3)
  String unit = "";
  @HiveField(4)
  String description = "";
  @HiveField(5)
  bool status = true;
  @HiveField(6)
  bool ativo = false;

  pidsDisc({
    required this.pid,
    required this.title
  });

  Map<String, dynamic> toJson() {
    return {
      "PID": pid.toString(),
      "length": lenght,
      "title": title,
      "unit": unit,
      "description": description,
      "status": true,
    };
  }
}
