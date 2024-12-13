import 'package:auto_route/auto_route.dart';
import '../route/autoroute.dart';

import 'package:flutter/material.dart';

@RoutePage()
class pidsdiscovery extends StatefulWidget {
  const pidsdiscovery({super.key});

  @override
  State<pidsdiscovery> createState() => _pidsdiscoveryState();
}

class _pidsdiscoveryState extends State<pidsdiscovery> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AutoTabsScaffold(
        appBarBuilder: (_, tabsRouter) => AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF008355),
          title: const Text(
            'Busca e Verificação de PIDs',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          centerTitle: true,
          leading: const AutoLeadingButton(),
        ),
        routes: const [
          Getallpids(),
          Getselectpids(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            backgroundColor: const Color(0xFF008355),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.withOpacity(0.9),
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.fact_check),
                label: 'Verificar Pids',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Buscar Pids',
              ),
            ],
          );
        },
      ),
    );
  }
}
