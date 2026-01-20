import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:obdapp/widgets/marketplace/marketplacewidget.dart';

@RoutePage()
class marketplace extends StatelessWidget {
  const marketplace({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketPlaceWidget();
  }
}