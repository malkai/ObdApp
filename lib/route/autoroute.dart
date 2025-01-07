import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:obdapp/functions/obdPlugin.dart';
import 'package:obdapp/screens/pidsDiscovery.dart';
import 'package:obdapp/screens/getAllPids.dart';

import '../screens/loadingPage.dart';
import '../screens/OBDdatacollect.dart';
import '../screens/appMainPage.dart';
import '../screens/configurePage.dart';
import '../screens/riderObdUserPage.dart';
import '../screens/historyRiderUserPage.dart';

part '../route/autoroute.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/initial', page: Appmain.page, children: [
         
          AutoRoute(path: 'ride', page: Ride.page),
          AutoRoute(path: 'conf', page: Configurepage.page),
        ]),
        AutoRoute(
          path: '/app',
          initial: true,
          page: Loadingpage.page,
        ),
        AutoRoute(
          path: '/obddta:obd2',
          page: Obddata.page,
        ),
        AutoRoute(path: '/pids:discovery', page: Pidsdiscovery.page, children: [
          AutoRoute(
            path: 'getallpids',
            page: Getallpids.page,
          ),
        
        ]),
      ];
}

class $AppRouter {}
