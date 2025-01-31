import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../functions/obdPlugin.dart';

import 'package:obdapp/functions/InternalDatabase.dart';

import '../widgets/dataConnect.dart';

@RoutePage()
class obddata extends StatelessWidget {
  final ObdPlugin obd2;
  final int value;

  const obddata({super.key, required this.obd2,  required this.value});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: (const Color(0xFF26B07F)),
              heroTag: "btn1",
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                //Apploadingrouter()
                var bancoInterno = InternalDatabase();
                await bancoInterno.handledata().then((value) {
                  context.router.popUntilRoot();
                });

                //
              },
            ),
          ],
        ),
        body: Data_Connect(
          obd2: obd2,
          value: value,
        ),
      ),
    );
  }
}
