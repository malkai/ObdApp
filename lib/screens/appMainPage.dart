import 'package:auto_route/auto_route.dart';
import '../route/autoroute.dart';
import 'package:flutter/material.dart';

import '../widgets/navigationWidget.dart';

@RoutePage()
class appmain extends StatelessWidget with ChangeNotifier {
  appmain({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AutoTabsScaffold(
        appBarBuilder: (_, tabsRouter) => AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF008355),
          title: const Text(
            'OBD APP',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          centerTitle: true,
          leading: const AutoLeadingButton(),
        ),
        routes: const [Ride(), Historyuser(), Configurepage()],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottonWidget(
            tabsRouter: tabsRouter,
          );
        },
      ),
    );
  }
}
