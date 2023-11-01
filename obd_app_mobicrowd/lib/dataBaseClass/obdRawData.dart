import 'package:hive_flutter/hive_flutter.dart';
part 'obdRawData.g.dart';

@HiveType(typeId: 2)
class Userdata {
  @HiveField(0)
  String name;
  @HiveField(1)
  UserVehicleRaw uservehicle;
  Userdata({
    required this.name,
    required this.uservehicle,
  });

  Map<String, dynamic> toJson() {
    return {'uservehicle': uservehicle.toJson()};
  }
}

@HiveType(typeId: 3)
class UserVehicleRaw {
  @HiveField(0)
  String vin;
  @HiveField(1)
  UserDataProcess userdata;
  UserVehicleRaw({
    required this.vin,
    required this.userdata,
  });

  Map<String, dynamic> toJson() {
    return {'vin': vin, 'userdata': userdata.toJson()};
  }
}

@HiveType(typeId: 4)
class UserDataProcess {
  @HiveField(0)
  bool isOnline;
  @HiveField(1)
  bool processada;
  @HiveField(2)
  String signature;
  @HiveField(3)
  List<ObdRawData> userdata;
  @HiveField(4)
  UserAcc acc;
  @HiveField(5)
  PositionClass pos;
  @HiveField(6)
  DateTime time;

  Map<dynamic, dynamic> listtoMap() {
    var map = {};
    for (var element in userdata) {
      map[element.pid] = {element.obddata.toJson()};
    }
    return map;
  }

  UserDataProcess(
      {required this.time,
      required this.isOnline,
      required this.userdata,
      required this.signature,
      required this.acc,
      required this.pos,
      required this.processada});

  Map<String, dynamic> toJson() {
    return {
      'isOnline': isOnline.toString(),
      'signature': signature,
      'userdata': userdata.map((tag) => tag.toJson()).toList(),
      'time': time.toString(),
      'acc': acc.toJson(),
      'pos': pos.toJson(),
      'processada': processada.toString(),
    };
  }
}

@HiveType(typeId: 5)
class UserAcc {
  @HiveField(0)
  String x;
  @HiveField(1)
  String y;
  @HiveField(2)
  String z;
  @HiveField(3)
  String unit;
  UserAcc({
    required this.x,
    required this.y,
    required this.z,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'z': z,
      'unit': unit,
    };
  }
}

@HiveType(typeId: 6)
class PositionClass {
  @HiveField(0)
  double long;
  @HiveField(1)
  double lat;
  PositionClass({
    required this.long,
    required this.lat,
  });
  Map<String, dynamic> toJson() {
    return {
      'long': long.toString(),
      'lat': lat.toString(),
    };
  }
}

@HiveType(typeId: 7)
class ObdRawData {
  @HiveField(0)
  String pid;
  @HiveField(1)
  ObdData obddata;
  ObdRawData({
    required this.pid,
    required this.obddata,
  });

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'obddata': obddata.toJson(),
    };
  }
}

@HiveType(typeId: 8)
class ObdData {
  @HiveField(0)
  String unit;
  @HiveField(1)
  String title;
  @HiveField(3)
  String response;
  ObdData({
    required this.unit,
    required this.title,
    required this.response,
  });

  Map<String, dynamic> toJson() {
    return {
      'unit': unit,
      'title': title,
      'response': response,
    };
  }
}
