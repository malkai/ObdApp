import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/initBluetooth.dart';

@RoutePage()
class ride extends StatelessWidget {
  const ride({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const InitBluetooth());
  }
}
