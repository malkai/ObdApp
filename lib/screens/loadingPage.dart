import 'package:flutter/material.dart';

import '../widgets/appLoading.dart';

class Loadingpage extends StatelessWidget {
  const Loadingpage({Key? key}) : super(key: key);

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
