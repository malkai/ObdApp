import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Accxyz extends StatefulWidget {
  const Accxyz({super.key});

  @override
  State<Accxyz> createState() => _AccxyzState();
}

class _AccxyzState extends State<Accxyz> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  UserAccelerometerEvent? _userAccelerometerEvent;
  Duration sensorInterval = SensorInterval.normalInterval;
  DateTime? _userAccelerometerUpdateTime;
  int? _userAccelerometerLastInterval;
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
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

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
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
                  Text(_userAccelerometerEvent?.x.toStringAsFixed(3) ?? '?'),
                ],
              ),
            ),
            Container(
              width: 55,
              child: Column(
                children: [
                  Text("Y"),
                  Text(_userAccelerometerEvent?.y.toStringAsFixed(3) ?? '?'),
                ],
              ),
            ),
            Container(
              width: 55,
              child: Column(
                children: [
                  Text("Z"),
                  Text(_userAccelerometerEvent?.z.toStringAsFixed(3) ?? '?'),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
