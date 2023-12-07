import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../autoroute/autoroute.gr.dart';
import '../widgets/navigationWidget.dart';

class appMain extends StatelessWidget with ChangeNotifier {
  appMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: AutoTabsScaffold(
      appBarBuilder: (_, tabsRouter) => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        title: const Text('INMETRO OBD'),
        centerTitle: true,
        leading: const AutoLeadingButton(),
      ),
      routes: const [Riderouter(), Historyrouter(), Confrouter()],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottonWidget(
          tabsRouter: tabsRouter,
        );
      },
    ));
  }
}
