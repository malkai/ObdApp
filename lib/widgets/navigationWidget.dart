import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class BottonWidget extends StatefulWidget {
  TabsRouter tabsRouter;

  BottonWidget({
    Key? key,
    required this.tabsRouter,
  }) : super(key: key);

  @override
  State<BottonWidget> createState() => _BottonWidgetState();
}

class _BottonWidgetState extends State<BottonWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        currentIndex: widget.tabsRouter.activeIndex,
        onTap: widget.tabsRouter.setActiveIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Corrida',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuração',
          ),
        ]);
  }
}
