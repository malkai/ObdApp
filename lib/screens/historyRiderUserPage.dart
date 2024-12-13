import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../widgets/historyriderlist.dart';

@RoutePage()
class historyuser extends StatelessWidget {
  const historyuser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const HistoryUserWidget());
  }
}
