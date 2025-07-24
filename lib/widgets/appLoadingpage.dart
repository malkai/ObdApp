import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../functions/InternalDatabase.dart';
import '../route/autoroute.dart';
import 'package:permission_handler/permission_handler.dart';

class AppLoading extends StatefulWidget {
  final String text;
  const AppLoading({super.key, this.text = ''});

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {
  Future<int> getAndroidSdk() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt ?? 30;
  }

  void init() async {
    if (Platform.isAndroid) {
      var statusto = await Permission.storage.status;
      if (!statusto.isGranted) {
        // If not we will ask for permission first
        await Permission.storage.request();
      }

      var statusblu = await Permission.bluetooth.status;
      if (!statusblu.isGranted && await getAndroidSdk() > 30) {
        await Permission.bluetooth.request();
        await Permission.bluetoothScan.request();
        await Permission.bluetoothConnect.request();

        // If not we will ask for permission first
      } else if (!statusblu.isGranted && await getAndroidSdk() < 30) {
        await Permission.bluetooth.request();
      }

      var statusloc = await Permission.location.status;
      if (!statusloc.isGranted) {
        // If not we will ask for permission first
        await Permission.location.request();
      }
    }
    var bancoInterno = InternalDatabase();
    bancoInterno.init();
    await bancoInterno.handledata().then((value) {
      context.router.replace(Appmain());
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(children: [
          const LinearProgressIndicator(
            color: Colors.indigo,
          ),
          Text(
            widget.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          )
        ]),
      ),
    );
  }
}
