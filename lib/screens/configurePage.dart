import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../widgets/conf.dart';

@RoutePage()
class configurepage extends StatelessWidget {
  const configurepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Confwidget();
  }
}
