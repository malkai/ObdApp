import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:obdapp/widgets/historywidgets/pagehistorywidget.dart';


@RoutePage()
class historyuser extends StatefulWidget {
  const historyuser({super.key});

  @override
  State<historyuser> createState() => _historyuserState();
}

class _historyuserState extends State<historyuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const HistoryWidget());
  }
}
