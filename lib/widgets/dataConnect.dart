import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';

import '../dataBaseClass/confSimu.dart';

import '../functions/obdPlugin.dart';
import '../widgets/textWidget.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../dataBaseClass/obdRawData.dart';
import '../functions/firebaseOptions.dart';
import '../functions/internalDatabase.dart';
import '../functions/security.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart' as path_prov;

class Data_Connect extends StatefulWidget {
  List<LatLng>? points;

  final ObdPlugin obd2;
  Function() turnOBD_OFF;
  bool statewidget;
  Data_Connect(
      {Key? key,
      required this.points,
      required this.obd2,
      required this.turnOBD_OFF,
      required this.statewidget})
      : super(key: key);
  static _ConnectState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  @override
  State<Data_Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Data_Connect> {
  final String _platformVersion = 'Unknown';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  List data = [];
  List<ObdRawData> _responses = [];
  List<Userdata> savejson = [];
  ObdData vin = ObdData(response: '', title: '', unit: '');
  late Box confapp;
  late Confdata confdata;

  bool teste = true;

  UserAccelerometerEvent? _userAccelEvt;

  bool _gpsServiceEnabled = false;

  LocationPermission? _permission;
  static Position? _position;
  late GeoPoint lastPosition;
  bool isLastPositionInitialized = false;
  double distanceInMeters = 0;
  Timer? _timer;

  var bancoInterno = InternalDatabase();

  static final LocationSettings _locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0,
  );
  late StreamSubscription<Position> _positionStream;

  Future<Position> _determinePosition() async {
    // Test if location services are enabled.
    _gpsServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_gpsServiceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    _permission ??= await Geolocator.checkPermission();

    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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
  void simuobdtime() {
    int i = 0;
    Timer.periodic(
      Duration(milliseconds: 2500),
      (timer) async {
        _timer = timer;
        print(i);

        if (widget.statewidget == true) {
          Random random = new Random();
          List<ObdRawData> _responses1 = [];
          ObdData help2 = ObdData(
              unit: "g/s",
              title: "fluxo de massa de ar (MAF)",
              response: (random.nextInt(
                          confdata.mafmax.toInt() - confdata.mafmin.toInt()) +
                      confdata.mafmin.toInt())
                  .toString());
          ObdRawData help1 = ObdRawData(pid: '01 10', obddata: help2);
          _responses1.add(help1);

          help2 = ObdData(
              unit: "Km/h",
              title: "velocidade",
              response: (random.nextInt(confdata.velomax - confdata.velomin) +
                      confdata.velomin)
                  .toString());
          help1 = ObdRawData(pid: '01 0D', obddata: help2);
          _responses1.add(help1);

          help2 = ObdData(
              unit: "kPa",
              title: "pressao absoluta do coletor de admissao",
              response: (random.nextInt(confdata.pressmax.toInt() -
                          confdata.pressmin.toInt()) +
                      confdata.pressmin.toInt())
                  .toString());
          help1 = ObdRawData(pid: '01 0B', obddata: help2);
          _responses1.add(help1);

          help2 = ObdData(
              unit: "\u00b0C",
              title: "temperatura do ar de entrada",
              response: (random.nextInt(confdata.tempaemax.toInt() -
                          confdata.tempaemin.toInt()) +
                      confdata.tempaemin.toInt())
                  .toString());
          help1 = ObdRawData(pid: '01 0F', obddata: help2);
          _responses1.add(help1);

          help2 = ObdData(
              unit: "\u00b0C",
              title: "Temperatura do liquido de arrefecimento",
              response: (random.nextInt(confdata.templamax.toInt() -
                          confdata.templamin.toInt()) +
                      confdata.templamin.toInt())
                  .toString());
          help1 = ObdRawData(pid: '01 0F', obddata: help2);
          _responses1.add(help1);

          vin = ObdData(unit: "", title: "VIN", response: confdata.vin);
          //help1 = ObdRawData(pid: '09 02 5', obddata: vin);
          //_responses1.add(help1);

          help2 = ObdData(
              unit: "%",
              title: "nivel de combustivel",
              response: (random.nextDouble() *
                          (confdata.pressmax - confdata.pressmin) +
                      confdata.pressmin)
                  .toString());
          help1 = ObdRawData(pid: '01 2F', obddata: help2);
          _responses1.add(help1);

          help2 = ObdData(
              unit: "RPM",
              title: "rotacao",
              response:
                  (random.nextDouble() * (confdata.rpmmax - confdata.rpmmin) +
                          confdata.rpmmin)
                      .toString());
          help1 = ObdRawData(pid: '01 0C', obddata: help2);
          _responses1.add(help1);
          setState(() {
            _responses = _responses1;
          });

          String? uniqueid;

          if (Platform.isIOS) {
            var iosDeviceInfo = await deviceInfo.iosInfo;
            uniqueid = iosDeviceInfo.identifierForVendor;
          } else if (Platform.isAndroid) {
            var androidDeviceInfo = await deviceInfo.androidInfo;
            uniqueid = androidDeviceInfo.id;
          }
          UserAcc acc = UserAcc(x: '', y: '', z: '', unit: '');
          PositionClass pc = PositionClass(lat: 0.0, long: 0.0);

          if (_userAccelEvt != null) {
            Map accel = {};
            accel['x'] = _userAccelEvt?.x.toString();
            accel['y'] = _userAccelEvt?.y.toString();
            accel['z'] = _userAccelEvt?.z.toString();
            accel['unit'] = 'm/s^2';
            acc.x = accel['x'];
            acc.y = accel['y'];
            acc.z = accel['z'];
            acc.unit = accel['unit'];
          }

          if (_position != null) {
            GeoPoint actualPosition =
                GeoPoint(_position!.latitude, _position!.longitude);
            pc.lat = actualPosition.latitude;
            pc.long = actualPosition.longitude;
            LatLng aux =
                LatLng(actualPosition.latitude, actualPosition.longitude);

            widget.points?.add(aux);
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
          UserVehicleRaw vehicledata =
              UserVehicleRaw(userdata: save, vin: vin.response);

          Userdata tobesaved =
              Userdata(name: uniqueid!, uservehicle: vehicledata);
          if (save.isOnline) {
            savejson.add(tobesaved);

            var userd = tobesaved.toJson();
            data.add(userd);
            //Repository.add(tobesaved);
            bancoInterno.insertObdData(tobesaved);
          } else {
            bancoInterno.insertObdData(tobesaved);
          }
          i++;

          await Future.delayed(
            Duration(milliseconds: 2500),
          );
        } else {
          timer.cancel();
        }
      },
    );
  }

  void sendrequestOBDData() {
    Timer.periodic(
      Duration(milliseconds: 2500),
      (timer) async {
        _timer = timer;
        if (widget.obd2.connection?.isConnected != false &&
            widget.obd2.connection?.isConnected != null) {
          await Future.delayed(
            Duration(
              milliseconds: await widget.obd2.getParamsFromJSON('''
        [        
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
                "PID": "09 02 5",
                "length": 5,
                "title": "VIN",
                "unit": "",
                "description": "<String>",
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
        ]
      '''),
            ),
          );
        } else {
          timer.cancel();
        }
      },
    );
  }

  void obdinfo() async {
    if (!(await widget.obd2.isListenToDataInitialed)) {
      widget.obd2.setOnDataReceived((command, response, requestCode) async {
        List resps = jsonDecode(response);

        List<ObdRawData> _responses1 = [];
        ObdData vin2 = ObdData(unit: '', title: '', response: '');
        print(resps);
        if (resps.isNotEmpty) {
          for (var reading in resps) {
            if (reading['PID'] == '09 02 5') {
              vin2.unit = reading['description'];
              vin2.title = reading['title'];
              vin2.response = reading['response'];
              vin = vin2;
            } else {
              ObdData help2 = ObdData(
                  unit: reading['unit'],
                  title: reading['title'],
                  response: reading['response']);
              ObdRawData help1 =
                  ObdRawData(pid: reading['PID'], obddata: help2);
              _responses1.add(help1);
            }
          }
        }
        setState(() {
          _responses = _responses1;
        });
        String? uniqueid;

        if (Platform.isIOS) {
          var iosDeviceInfo = await deviceInfo.iosInfo;
          uniqueid = iosDeviceInfo.identifierForVendor;
        } else if (Platform.isAndroid) {
          var androidDeviceInfo = await deviceInfo.androidInfo;
          uniqueid = androidDeviceInfo.id;
        }
        UserAcc acc = UserAcc(x: '', y: '', z: '', unit: '');
        PositionClass pc = PositionClass(lat: 0.0, long: 0.0);

        if (_userAccelEvt != null) {
          Map accel = {};
          accel['x'] = _userAccelEvt?.x.toString();
          accel['y'] = _userAccelEvt?.y.toString();
          accel['z'] = _userAccelEvt?.z.toString();
          accel['unit'] = 'm/s^2';
          acc.x = accel['x'];
          acc.y = accel['y'];
          acc.z = accel['z'];
          acc.unit = accel['unit'];
        }

        if (_position != null) {
          GeoPoint actualPosition =
              GeoPoint(_position!.latitude, _position!.longitude);
          pc.lat = actualPosition.latitude;
          pc.long = actualPosition.longitude;
          LatLng aux =
              LatLng(actualPosition.latitude, actualPosition.longitude);

          widget.points?.add(aux);
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
        UserVehicleRaw vehicledata =
            UserVehicleRaw(userdata: save, vin: vin.response);

        Userdata tobesaved =
            Userdata(name: uniqueid!, uservehicle: vehicledata);
        if (save.isOnline) {
          savejson.add(tobesaved);

          var userd = tobesaved.toJson();
          data.add(userd);
          //Repository.add(tobesaved);
          bancoInterno.insertObdData(tobesaved);
        } else {
          bancoInterno.insertObdData(tobesaved);
        }
      });
      sendrequestOBDData();
    }
  }

  void getinfo() async {
    final diretorioUsuario = await path_prov.getApplicationDocumentsDirectory();

    //print(path_prov.getDownloadsDirectory());
    //print(path_prov.getLibraryDirectory());
    File file = new File(
        diretorioUsuario.path + "/" + DateTime.now().toString() + '.json');
    String terre = diretorioUsuario.path + "/" + DateTime.now().toString();
    file.create();
    int ui = 0;

    if (confdata.on == true) {
      simuobdtime();
    } else {
      obdinfo();
    }

    ui++;
  }

  void init() async {
    confapp = await Hive.openBox<Confdata>('conf');
    confdata = confapp.getAt(0);
  }

  void saveData() async {
    //bool fileExists = true;

    //DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    init();
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (event != null) _userAccelEvt = event;
    });

    _positionStream =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
      _position = position;
    });

    getinfo();
  }

  @override
  void dispose() async {
    super.dispose();
    _timer!.cancel();
    final diretorioUsuario = await path_prov.getApplicationDocumentsDirectory();

    //print(path_prov.getDownloadsDirectory());
    //print(path_prov.getLibraryDirectory());
    File file = new File(
        diretorioUsuario.path + "/" + DateTime.now().toString() + '.json');
    String terre = diretorioUsuario.path + "/" + DateTime.now().toString();
    file.create();
    const JsonEncoder encoder = JsonEncoder();
    final String jsonString = encoder.convert(data);
    file.writeAsStringSync(jsonString);
    _positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Textdata(
                  tipo: 'PID VIN',
                  texto: vin.response == '' ? 'PID VIN' : vin.response,
                ),
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
                          texto: _responses[i].obddata.unit == ''
                              ? 'PID $i'
                              : _responses[i].obddata.response +
                                  ' ' +
                                  _responses[i].obddata.unit,
                        ),
                      ],
                    );
                  },
                ),
              ],
            )));
  }
}
