import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:obdapp/dataBaseClass/confSimu.dart';
import 'package:obdapp/dataBaseClass/obdRawData.dart';
import 'package:obdapp/dataBaseClass/pidDiscoveryClass.dart';
import 'package:obdapp/dataBaseClass/vehiclesUser.dart';
import 'package:obdapp/functions/InternalDatabase.dart';
import 'package:obdapp/route/autoroute.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'functions/firebaseOptions.dart';
import 'package:path_provider/path_provider.dart' as path_prov;

//

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final diretorioUsuario = await path_prov.getApplicationDocumentsDirectory();
  await Hive.initFlutter(diretorioUsuario.path);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Hive.registerAdapter(UserdataAdapter());
  Hive.registerAdapter(UserVehicleRawAdapter());
  Hive.registerAdapter(UserDataProcessAdapter());
  Hive.registerAdapter(UserAccAdapter());
  Hive.registerAdapter(PositionClassAdapter());
  Hive.registerAdapter(ObdRawDataAdapter());
  Hive.registerAdapter(ObdDataAdapter());
  Hive.registerAdapter(UserVehiclesAdapter());
  Hive.registerAdapter(ConfdataAdapter());
  Hive.registerAdapter(VinAdapter());
  Hive.registerAdapter(pidsDiscAdapter());
  var bancoInterno = InternalDatabase();
  bancoInterno.init();
  await Hive.openBox<Confdata>('conf');
  if (Platform.isAndroid) {
    var statusto = await Permission.storage.status;
    if (!statusto.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }

    var statusblu = await Permission.bluetooth.status;
    if (!statusblu.isGranted) {
      // If not we will ask for permission first
      await Permission.bluetooth.request();
    }

    var statusloc = await Permission.location.status;
    if (!statusloc.isGranted) {
      // If not we will ask for permission first
      await Permission.location.request();
    }
  }
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  runApp(const MyApp());
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(
        "Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

@override
void dispose() async {}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF26B07F),
          // ···
        ),
      ),
    );
  }
}
