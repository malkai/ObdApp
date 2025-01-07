import 'package:hive_flutter/hive_flutter.dart';
part 'confSimu.g.dart';

/*

  {
                "PID": "01 0C",
                "length": 2,
                "title": "rotacao",
                "unit": "RPM",
                "description": "<double>, (( [0] * 256) + [1] ) / 4",
                "status": true
            },
            {
                "PID": "01 0D",
                "length": 1,
                "title": "velocidade",
                "unit": "Km/h",
                "description": "<int>, [0]",
                "status": true
            },
            {
                "PID": "01 05",
                "length": 1,
                "title": "temperatura do liquido de arrefecimento",
                "unit": "°C",
                "description": "<int>, ( [0] - 40 )",
                "status": true
            },
            {
                "PID": "01 0B",
                "length": 1,
                "title": "pressao absoluta do coletor de admissao",
                "unit": "kPa",
                "description": "<int>, [0]",
                "status": true
            },
            {
                "PID": "09 02 5",
                "length": 5,
                "title": "VIN",
                "unit": "",
                "description": "<String>",
                "status": true
            },
            {
                "PID": "01 0F",
                "length": 1,
                "title": "temperatura do ar de entrada",
                "unit": "°C",
                "description": "<int>, ( [0] - 40 )",
                "status": true
            },
            {
                "PID": "01 10",
                "length": 2,
                "title": "fluxo de massa de ar (MAF)",
                "unit": "g/s",
                "description": "<double>, (( [0] * 256 ) + [1] ) / 100",
                "status": true
            },
            {
                "PID": "01 2F",
                "length": 1,
                "title": "nivel de combustivel",
                "unit": "%",
                "description": "<int>, ( [0] * 100 ) / 255",
                "status": true
            }

*/
@HiveType(typeId: 9)
class Confdata {
  //750 - 10.000
  @HiveField(0)
  double rpmmin;
  @HiveField(1)
  double rpmmax;

  //0 - 120
  @HiveField(2)
  int velomin;
  @HiveField(3)
  int velomax;

  //90 - 104.4
  @HiveField(4)
  double templamin;
  @HiveField(5)
  double templamax;

  //14.7 - 101
  @HiveField(6)
  double pressmin;
  @HiveField(7)
  double pressmax;

  @HiveField(8)
  String vin;

  //30 - 70
  @HiveField(10)
  double tempaemin;
  @HiveField(11)
  double tempaemax;

  //400 to 1000
  @HiveField(12)
  double mafmin;
  @HiveField(13)
  double mafmax;

  //0 to 100
  @HiveField(14)
  int percentmin;
  @HiveField(15)
  int percentmax;

  @HiveField(16)
  bool on;

  @HiveField(17)
  bool obd = true;

  @HiveField(18)
  bool acc = true;

  @HiveField(19)
  bool watch = false;

  @HiveField(20)
  bool phone = true;

  @HiveField(21)
  bool gps = true;

  @HiveField(22)
  List<getobddata> responseobddata;

  @HiveField(23)
  String name;

  @HiveField(24)
  String timereqobd;

  Confdata({
    required this.rpmmax,
    required this.rpmmin,
    required this.mafmax,
    required this.mafmin,
    required this.percentmax,
    required this.percentmin,
    required this.pressmax,
    required this.pressmin,
    required this.tempaemax,
    required this.tempaemin,
    required this.templamax,
    required this.templamin,
    required this.velomax,
    required this.velomin,
    required this.vin,
    required this.on,
    required this.responseobddata,
    required this.name,
    required this.timereqobd,
  });
}

@HiveType(typeId: 10)
class getobddata {
  //750 - 10.000
  @HiveField(0)
  String pid;
  @HiveField(1)
  String length;

  //0 - 120
  @HiveField(2)
  String title;
  @HiveField(3)
  String unit;

  //90 - 104.4
  @HiveField(4)
  String description;
  @HiveField(5)
  String status;

  //14.7 - 101

  getobddata({
    required this.pid,
    required this.length,
    required this.title,
    required this.unit,
    required this.description,
    required this.status,
  });
}
