import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (option) {
        print(option);
        setState(() {
          optionindex = option;

          widget.tabsRouter.setActiveIndex(option);
        });
      },
      backgroundColor: const Color(0xFF008355),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.withOpacity(0.9),
      currentIndex: optionindex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Corrida',
        ),
       // BottomNavigationBarItem(
        //  icon: Icon(Icons.business),
        //  label: 'Histórico',
        //),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuração',
        ),
      ],
    );
  }
}
