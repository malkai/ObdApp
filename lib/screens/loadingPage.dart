import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../widgets/appLoading.dart';

@RoutePage()
class loadingpage extends StatelessWidget {
  const loadingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Loading Page',
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w300),
          ),
          AppLoading(),
        ],
      )),
    );
  }
}
