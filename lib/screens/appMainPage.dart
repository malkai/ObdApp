import 'package:auto_route/auto_route.dart';
import 'package:obdapp/widgets/pagemainwidget.dart';
import '../route/autoroute.dart';
import 'package:flutter/material.dart';

import '../widgets/navigationWidget.dart';

@RoutePage()
class appmain extends StatelessWidget {
  appmain({super.key});

  @override
  Widget build(BuildContext context) {
    return pagemainwidget();
  }
}
