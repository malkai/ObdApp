import 'package:auto_route/auto_route.dart';
import 'package:hive/hive.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/blockchain.dart';
import 'package:obdapp/widgets/pagemainwidget.dart';
import '../route/autoroute.dart';
import 'package:flutter/material.dart';

import '../widgets/navigationWidget.dart';

class pagemainwidget extends StatefulWidget {
  const pagemainwidget({super.key});

  @override
  State<pagemainwidget> createState() => _pagemainwidgetState();
}

class _pagemainwidgetState extends State<pagemainwidget> {
  blockchain auxblock = blockchain();
  wallet user = wallet(add: "", name: "");
  late Box userdata;

  void init() async {
    userdata = await Hive.openBox<wallet>('wallet');
    print(userdata.length);
    setState(() {
      user = userdata.getAt(0);
    });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

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
        routes: (user.blockchain)
            ? [Ride(), Historyuser(), Marketplace(), Configurepage()]
            : [Ride(), Configurepage()],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottonWidget(
            tabsRouter: tabsRouter,
          );
        },
      ),
    );
  }
}
