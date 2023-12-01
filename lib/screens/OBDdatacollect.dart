import 'package:flutter/material.dart';
import '../functions/obdPlugin.dart';
import '../widgets/initBluetooth.dart';
import '../widgets/obdDataBoxWidget.dart';

class OBDdata extends StatefulWidget {
  ObdPlugin obd2;
  Function() turnOBD_OFF;
  bool logic;
  OBDdata(
      {Key? key,
      required this.obd2,
      required this.turnOBD_OFF,
      required this.logic})
      : super(key: key);

  @override
  State<OBDdata> createState() => _OBDdataState();
}

class _OBDdataState extends State<OBDdata> {
  @override
  Widget build(BuildContext context) {
    return ObdDataMap(
        obd2: widget.obd2, turnOBD_OFF: widget.turnOBD_OFF, help: widget.logic);
  }
}
