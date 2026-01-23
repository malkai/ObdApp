import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/widgets/MapGpswidget.dart';
import 'package:obdapp/widgets/accxyzpage.dart';

import '../dataBaseClass/confSimu.dart';

import '../dataBaseClass/pidDiscoveryClass.dart';
import '../functions/obdPlugin.dart';
import 'textWidget.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../dataBaseClass/obdRawData.dart';
import '../functions/security.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart' as path_prov;
import '../functions/InternalDatabase.dart';

class Data_Connect extends StatefulWidget {
  final ObdPlugin obd2;

  final int value;

  const Data_Connect({
    super.key,
    required this.value,
    required this.obd2,
  });
  static _ConnectState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  @override
  State<Data_Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Data_Connect> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  List data = [];
  List<ObdRawData> _responses = [];
  List<Userdata> savejson = [];
  List<LatLng> points = [];

  ObdData vin = ObdData(response: '', title: '', unit: '');
  MainAxisAlignment aligm = MainAxisAlignment.center;

  bool teste = true;

  Timer t = Timer(Duration(seconds: 0), () {});
  Timer t2 = Timer(Duration(seconds: 0), () {});

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  UserAccelerometerEvent? _userAccelerometerEvent;
  Duration sensorInterval = SensorInterval.normalInterval;
  DateTime? _userAccelerometerUpdateTime;
  int? _userAccelerometerLastInterval;
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  UserAcc acc = UserAcc(x: '', y: '', z: '', unit: '');

  String? uniqueid;

  static Position? _position;
  late GeoPoint lastPosition;
  bool isLastPositionInitialized = false;
  double distanceInMeters = 0;
  Timer? _timer;

  double comb = 0;

  Box? confapp;
  late Box pidDisc;
  late pidsDisc pidDiskcong;
  Confdata? confdata;
  var bancoInterno = InternalDatabase();

  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0,
  );
  StreamSubscription<Position>? _positionStream;

  void updatemap() {
    setState(() {
      points;
    });
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {}
    return false;
  }

  /*

           
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
  */

  PositionClass getGps(PositionClass pc) {
    GeoPoint actualPosition =
        GeoPoint(_position!.latitude, _position!.longitude);

    PositionClass pc = PositionClass(
        lat: actualPosition.latitude, long: actualPosition.longitude);
    pc.lat = roundDouble(actualPosition.latitude, 4);
    pc.long = roundDouble(actualPosition.longitude, 4);
    LatLng aux = LatLng(roundDouble(actualPosition.latitude, 4),
        roundDouble(actualPosition.longitude, 4));

    if (actualPosition.latitude != 0.0 && actualPosition.longitude != 0.0) {
      if (points.length > 1 && points.length < 2) {
        var distance = Distance();
        //create a new distance calculator with Haversine algorithm
        distance = const Distance(calculator: Haversine());

        //create coordinates with NaN or Infinity state to check if the distance is calculated correctly
        final point1 = aux;
        final point2 = points[0];

        var meterDistance = distance.as(LengthUnit.Meter, point1, point2);

        if (meterDistance < 55.00) {
          points.add(aux);
        } else {
          points[0] = aux;
        }
      } else {
        points.add(aux);
      }

      return pc;
    }

    return pc;
  }

  void accuser(String x, y, z, unit) {
    if (_userAccelerometerEvent != null) {
      Map accel = {};
      accel['x'] = _userAccelerometerEvent?.x.toStringAsFixed(3);
      accel['y'] = _userAccelerometerEvent?.y.toStringAsFixed(3);
      accel['z'] = _userAccelerometerEvent?.z.toStringAsFixed(3);
      accel['unit'] = 'm/s^2';
      x = accel['x'];
      y = accel['y'];
      z = accel['z'];
      unit = accel['unit'];
    }
  }

  void simuobdtime(PositionClass pc, int count) {
    Timer.periodic(Duration(seconds: int.parse(confdata!.timereqobd)),
        (timer) async {
          

      int count_aux = count;
      _timer = timer;

     
      if (confdata!.gps && _position != null && timer.isActive ) {
        pc = getGps(pc);

        if (pc.lat != 0 && pc.long != 0) {
          count_aux -= 1;
        }
        updatemap();
        setState(() {
          points;
        });
      }

      if (confdata!.acc && timer.isActive) {
        count_aux -= 1;
        accuser(acc.x, acc.y, acc.z, acc.unit);
      }

      if (confdata!.obd) {
        count_aux -= 1;
        Random random = Random();
        List<ObdRawData> responses1 = [];
        late ObdData help2;
        late ObdRawData help1;

        if (confdata!.maf) {
          help2 = ObdData(
              unit: "g/s",
              title: "fluxo de massa de ar (MAF)",
              response: (random.nextInt(
                          confdata!.mafmax.toInt() - confdata!.mafmin.toInt()) +
                      confdata!.mafmin.toInt())
                  .toString());
          help1 = ObdRawData(pid: '01 10', obddata: help2);
          responses1.add(help1);
        }

        if (confdata!.percent) {
          help2 = ObdData(
              unit: "%",
              title: "nivel de combustivel",
              response: comb.toStringAsFixed(2));
          help1 = ObdRawData(pid: '01 2F', obddata: help2);
          responses1.add(help1);
        }
        // nível de combustível

        if (confdata!.press) {
          help2 = ObdData(
              unit: "kPa",
              title: "pressao absoluta do coletor de admissao",
              response: (random.nextInt(confdata!.pressmax.toInt() -
                          confdata!.pressmin.toInt()) +
                      confdata!.pressmin.toInt())
                  .toString());
          help1 = ObdRawData(pid: '01 0B', obddata: help2);
          responses1.add(help1);
        }

        if (confdata!.rpm) {
          help2 = ObdData(
              unit: "RPM",
              title: "rotacao",
              response:
                  (random.nextDouble() * (confdata!.rpmmax - confdata!.rpmmin) +
                          confdata!.rpmmin)
                      .toString());
          help1 = ObdRawData(pid: '01 0C', obddata: help2);
          responses1.add(help1);
        }

        // print(widget.points.length);
        if (confdata!.tempa) {
          help2 = ObdData(
              unit: "\u00b0C",
              title: "temperatura do ar de entrada",
              response: (random.nextInt(confdata!.tempaemax.toInt() -
                          confdata!.tempaemin.toInt()) +
                      confdata!.tempaemin.toInt())
                  .toString());
          help1 = ObdRawData(pid: '01 0F', obddata: help2);
          responses1.add(help1);
        }

        if (confdata!.templa) {
          help2 = ObdData(
              unit: "\u00b0C",
              title: "Temperatura do liquido de arrefecimento",
              response: (random.nextInt(confdata!.templamax.toInt() -
                          confdata!.templamin.toInt()) +
                      confdata!.templamin.toInt())
                  .toString());
          help1 = ObdRawData(pid: '01 0F', obddata: help2);
          responses1.add(help1);
        }

        if (confdata!.velo) {
          help2 = ObdData(
              unit: "Km/h",
              title: "velocidade",
              response: (random.nextInt(confdata!.velomax - confdata!.velomin) +
                      confdata!.velomin)
                  .toString());
          help1 = ObdRawData(pid: '01 0D', obddata: help2);
          responses1.add(help1);
        }
        late Box userdata;
        userdata = await Hive.openBox<wallet>('wallet');

        wallet user = wallet(add: "", name: "");
        user = userdata.getAt(0);
        vin = ObdData(unit: "", title: "VIN", response: user.vin);
        //help1 = ObdRawData(pid: '09 02 5', obddata: vin);
        //_responses1.add(help1);
        if (timer.isActive) {
          setState(() {
            _responses = responses1;
          });
        }
      }

      bool a = await checkUserConnection();


   

      if (count_aux == 0) {
        print("elemento");
        print({pc.lat, pc.long});

        UserDataProcess save = UserDataProcess(
            processada: false,
            isOnline: false,
            signature: '',
            userdata: _responses,
            acc: acc,
            pos: pc,
            time: DateTime.now());
        //var signature = await sign(save).then((signature) => signature);
        //save.signature = signature.toString();
        late Box userdata;
        userdata = await Hive.openBox<wallet>('wallet');

        wallet user = wallet(add: "", name: "");
        user = userdata.getAt(0);
        UserVehicleRaw vehicledata =
            UserVehicleRaw(userdata: save, vin: user.vin);

        Userdata tobesaved =
            Userdata(name: uniqueid!, uservehicle: vehicledata);
        savejson.add(tobesaved);

        var userd = tobesaved.toJson();
        data.add(userd);
        if (save.isOnline) {
          //Repository.add(tobesaved);
          bancoInterno.insertObdData(tobesaved);
        } else {
          bancoInterno.insertObdData(tobesaved);
        }
      }
      comb = comb - 0.001;
    });
  }

  void obdinfo(PositionClass pc, int count) async {
    if (!(await widget.obd2.isListenToDataInitialed)) {
      widget.obd2.setOnDataReceived((command, response, requestCode) async {
        if (confdata!.gps && _position != null) {
          pc = getGps(pc);
          updatemap;
        }

        List resps = jsonDecode(response);
        List<ObdRawData> responses1 = [];
        ObdData vin2 = ObdData(unit: '', title: '', response: '');

        if (resps.isNotEmpty) {
          for (var reading in resps) {
            {
              ObdData help2 = ObdData(
                  unit: reading['unit'],
                  title: reading['title'],
                  response: reading['response']);
              ObdRawData help1 =
                  ObdRawData(pid: reading['PID'], obddata: help2);

              responses1.add(help1);
            }
          }

          _responses.clear;
          setState(() {
            _responses = responses1;
          });

          if (confdata!.acc) {
            accuser(acc.x, acc.y, acc.z, acc.unit);
          }
          bool a = await checkUserConnection();

          UserDataProcess save = UserDataProcess(
              processada: false,
              isOnline: a,
              signature: '',
              userdata: _responses,
              acc: acc,
              pos: pc,
              time: DateTime.now());
          var signature = await sign(save).then((signature) => signature);
          save.signature = signature.toString();
          late Box userdata;
          userdata = await Hive.openBox<wallet>('wallet');

          wallet user = wallet(add: "", name: "");
          user = userdata.getAt(0);

          UserVehicleRaw vehicledata =
              UserVehicleRaw(userdata: save, vin: user.vin);

          Userdata tobesaved =
              Userdata(name: uniqueid!, uservehicle: vehicledata);
          savejson.add(tobesaved);

          var userd = tobesaved.toJson();
          print(userd);
          data.add(userd);

          if (save.isOnline) {
            //Repository.add(tobesaved);
            //bancoInterno.insertObdData(tobesaved);
          } else {
            //bancoInterno.insertObdData(tobesaved);
          }
        }
      });
    }

    /*

    var requeridResponse = [
      {
        "PID": "01 00",
        "length": 4,
        "title": "PIDs supported [01 - 20]",
        "unit": "",
        "description": "<bit>",
        "status": true
      },
      {
        "PID": "01 20",
        "length": 4,
        "title": "PIDs supported [21 - 40]",
        "unit": "",
        "description": "<bit>",
        "status": true
      },
      {
        "PID": "01 40",
        "length": 4,
        "title": "PIDs supported [41 - 60]",
        "unit": "",
        "description": "<bit>",
        "status": true
      },
      {
        "PID": "01 60",
        "length": 4,
        "title": "PIDs supported [61 - 80]",
        "unit": "",
        "description": "<bit>",
        "status": true
      },
      {
        "PID": "01 80",
        "length": 4,
        "title": "PIDs supported [81  - A0]",
        "unit": "",
        "description": "<bit>",
        "status": true
      },
      {
        "PID": "01 A0",
        "length": 4,
        "title": "PIDs supported [A1  - C0]",
        "unit": "",
        "description": "<bit>",
        "status": true
      },
    ];
    

    int count = 0;
int j = 1;
    int count = 0;

      print(_responses.length);
      while (_responses.length < j) {
        t = Timer(Duration(seconds: 1), () {
          count += 1;
          print(count);
        });
      }

      _responses[j - 1].timer = count;
      j++;
      count = 0;

*/

    senrequestOBDData();

    //setState(() {
    // _responses;
    //});
  }

  void checkpis(var ui) async {
    String jsonString = json.encode([ui]);

    if (widget.obd2.connection?.isConnected != false &&
        widget.obd2.connection?.isConnected != null) {
      await widget.obd2.getParamsFromJSON(jsonString);
    }
  }

  Future<void> senrequestOBDData() async {
    pidDiskcong = pidDisc.getAt(widget.value);
    String pid1, title1, unit1, desc1;
    pid1 = pidDiskcong.pid;
    title1 = pidDiskcong.title;
    unit1 = pidDiskcong.unit;
    desc1 = pidDiskcong.description;
    var oneSec = Duration(seconds: int.parse(confdata!.timereqobd));
    t2 = Timer.periodic(oneSec, (Timer t) async {
      if (widget.obd2.connection?.isConnected != false &&
          widget.obd2.connection?.isConnected != null) {
        await Future.delayed(
          Duration(
            seconds: await widget.obd2.getParamsFromJSON('''
        [        
           
            {
                "PID": "$pid1",
                "title": "$title1",
                "unit": "$unit1",
                "description": "$desc1"
            }
        ]
      '''),
          ),
        );
      }
    });

    /*
    Timer.periodic(
      Duration(seconds: int.parse(confdata!.timereqobd)),
      (timer) async {
        _timer = timer;
        if (widget.obd2.connection?.isConnected != false &&
            widget.obd2.connection?.isConnected != null) {
          await Future.delayed(
            Duration(
              seconds: await widget.obd2.getParamsFromJSON('''
        [        
           
            {
                "PID": "01 2F",
                "length": 1,
                "title": "nivel de combustivel",
                "unit": "%",
                "description": "<int>, ( [0] * 100 ) / 255",
                "status": true
            }
        ]
      '''),
            ),
          );
        } else {
          print("oi");
          timer.cancel();
        }

        print("terminou3");
      },
    );
    */
  }

  void getinfo() async {
    final diretorioUsuario = await path_prov.getApplicationDocumentsDirectory();

    File file =
        File(diretorioUsuario.path + "/" + DateTime.now().toString() + '.json');
    String terre = "${diretorioUsuario.path}/${DateTime.now()}";
    file.create();
    PositionClass pc = PositionClass(lat: 0, long: 0);
    int count = 0;

    if (confdata!.obd) {
      count += 1;
    }
    if (confdata!.gps) {
      count += 1;
    }
    if (confdata!.acc) {
      count += 1;
    }

    if (confdata!.obd) {
      if (confdata!.on) {
        print("oi1");
        simuobdtime(pc, count);
      } else {
        print("oi2");
        obdinfo(pc, count);
      }
    } else {
      print("oi3");
      simuobdtime(pc, count);
    }
  }

  Future<void> init() async {
    Random random = Random();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueid = iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueid = androidDeviceInfo.id;
    }
    confapp = await Hive.openBox<Confdata>('conf');

    if (confapp == null) {
      var bancoInterno = InternalDatabase();
      bancoInterno.init();

      late Box userdata;
      userdata = await Hive.openBox<wallet>('wallet');

      wallet user = wallet(add: "", name: "");
      user = userdata.getAt(0);

      var a = Confdata(
          rpmmin: 750,
          rpmmax: 10000,
          velomin: 0,
          velomax: 120,
          templamin: 90,
          templamax: 104.4,
          pressmin: 14.7,
          pressmax: 101,
          vin: user.vin,
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
      confdata = a;
      comb =
          (random.nextDouble() * (confdata!.percentmax - confdata!.percentmin) +
              confdata!.percentmin);
    } else {
      confdata = confapp!.getAt(0);
      setState(() {
        confdata;
      });
      comb =
          (random.nextDouble() * (confdata!.percentmax - confdata!.percentmin) +
              confdata!.percentmin);
    }

    pidDisc = await Hive.openBox<pidsDisc>('pidsDisc');
  }

  @override
  void initState() {
    super.initState();
    init().then((value) {
      if (confdata!.acc) {
        _streamSubscriptions.add(
          userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
            (UserAccelerometerEvent event) {
              final now = event.timestamp;
              setState(() {
                _userAccelerometerEvent = event;
                if (_userAccelerometerUpdateTime != null) {
                  final interval =
                      now.difference(_userAccelerometerUpdateTime!);
                  if (interval > _ignoreDuration) {
                    _userAccelerometerLastInterval = interval.inMilliseconds;
                  }
                }
              });
              _userAccelerometerUpdateTime = now;
            },
            onError: (e) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      title: Text("Sensor Not Found"),
                      content: Text(
                          "It seems that your device doesn't support User Accelerometer Sensor"),
                    );
                  });
            },
            cancelOnError: true,
          ),
        );
      }

      if (confdata!.gps) {
        _positionStream =
            Geolocator.getPositionStream(locationSettings: _locationSettings)
                .listen((Position? position) {
          //print(position == null
          //    ? 'Unknown'
          //    : '${position.latitude.toString()}, ${position.longitude.toString()}');
          _position = position;
        });
      }

      getinfo();
    });
  }

  @override
  void dispose() async {
    super.dispose();

    await _positionStream?.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }

    if (await widget.obd2.hasConnection) {
      await widget.obd2.connection!.close();
    }

    final diretorioUsuario = await path_prov.getExternalStorageDirectory();

    File file = File(
        diretorioUsuario!.path + "/" + DateTime.now().toString() + '.json');

    file.create();
    const JsonEncoder encoder = JsonEncoder();

    final String jsonString = encoder.convert(data);
    file.writeAsStringSync(jsonString);
    if (_positionStream != null) {
      _positionStream!.cancel();
    }

    if (_timer != null) {
      _timer!.cancel();
    }

    data.clear();
    _responses.clear();
    savejson.clear();
    points.clear();

    await widget.obd2.connection?.close();
    await widget.obd2.connection?.finish();
    widget.obd2.connection?.dispose();
    t.cancel();
    t2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        mainAxisAlignment: aligm,
        children: [
          if (confdata?.acc ?? false)
            Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Accxyz(
                    x: _userAccelerometerEvent?.x.toStringAsFixed(3) ?? "?",
                    y: _userAccelerometerEvent?.y.toStringAsFixed(3) ?? "?",
                    z: _userAccelerometerEvent?.z.toStringAsFixed(3) ?? "?")),
          SizedBox(height: 10),
          if (confdata?.gps ?? false)
            Builder(builder: (BuildContext context) {
              return Column(
                children: [
                  Text("GPS"),
                  SizedBox(height: 10),
                  SizedBox(height: 300, child: MapWidget(points: points)),
                ],
              );
            }),
          SizedBox(height: 10),
          if (confdata?.obd ?? false)
            Column(
              children: [
                SizedBox(height: 10),
                Text("Informações do OBD"),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _responses.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      Textdata(
                                        // print([i.pid, i.obddata.unit]);
                                        tipo: _responses[i].obddata.title == ''
                                            ? 'PID $i'
                                            : _responses[i].obddata.title,
                                        texto: _responses[i].obddata.response ==
                                                ''
                                            ? 'PID $i'
                                            : '${_responses[i].obddata.response} ${_responses[i].obddata.unit}',
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ))),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
