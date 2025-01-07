import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Accxyz extends StatefulWidget {

  final String x,y,z;
  const Accxyz({ required this.x, required this.y, required this.z, super.key});

  @override
  State<Accxyz> createState() => _AccxyzState();
}

class _AccxyzState extends State<Accxyz> {
  


  @override
  void dispose() {
    super.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text("Acelerometro"),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 55,
              child: Column(
                children: [
                  Text("X"),
                  Text(widget.x ?? '?'),
                ],
              ),
            ),
            Container(
              width: 55,
              child: Column(
                children: [
                  Text("Y"),
                  Text(widget.y ?? '?'),
                ],
              ),
            ),
            Container(
              width: 55,
              child: Column(
                children: [
                  Text("Z"),
                  Text(widget.z ?? '?'),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
