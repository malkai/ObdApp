import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:obdapp/dataBaseClass/blockchainid.dart';
import 'package:obdapp/functions/blockchain.dart';

class BottonWidget extends StatefulWidget {
  TabsRouter tabsRouter;

  BottonWidget({
    super.key,
    required this.tabsRouter,
  });

  @override
  State<BottonWidget> createState() => _BottonWidgetState();
}

class _BottonWidgetState extends State<BottonWidget> {
  int optionindex = 0;

  blockchain auxblock = blockchain();
  wallet user = wallet(add: "", name: "");
  late Box userdata;

  void init() async {
    userdata = await Hive.openBox<wallet>('wallet');
    setState(() {
      user = userdata.getAt(0);
      optionindex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    print("init page");
    print(optionindex);
  }

  @override
  void dispose() {
    super.dispose();
    optionindex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Ride"),
      if (user.blockchain)
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
      if (user.blockchain)
        BottomNavigationBarItem(icon: Icon(Icons.store), label: "Market"),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
    ];

    if (optionindex >= items.length) {
      optionindex = 0;
    }

    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          optionindex = index;

          widget.tabsRouter.setActiveIndex(optionindex);
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF008355),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.withOpacity(0.9),
      currentIndex: optionindex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Corrida',
        ),
        if (user.blockchain)
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Histórico',
          ),
        if (user.blockchain)
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Loja',
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuração',
        ),
      ],
    );
  }
}
