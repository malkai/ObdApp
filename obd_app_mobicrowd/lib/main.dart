import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'autoroute/autoroute.gr.dart';
import 'functions/firebaseOptions.dart';
import 'package:path_provider/path_provider.dart' as path_prov;

//

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final diretorioUsuario = await path_prov.getApplicationDocumentsDirectory();
  await Hive.initFlutter(diretorioUsuario.path);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
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
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
