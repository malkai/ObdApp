// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../functions/obdPlugin.dart' as _i9;
import '../screens/appMainPage.dart' as _i1;
import '../screens/configurePage.dart' as _i6;
import '../screens/historyRiderUserPage.dart' as _i4;
import '../screens/loadingPage.dart' as _i2;
import '../screens/OBDdatacollect.dart' as _i3;
import '../screens/riderObdUserPage.dart' as _i5;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    Initialrouter.name: (routeData) {
      final args = routeData.argsAs<InitialrouterArgs>(
          orElse: () => const InitialrouterArgs());
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.appMain(key: args.key),
      );
    },
    Apploadingrouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.Loadingpage(),
      );
    },
    Obddtarouter.name: (routeData) {
      final args = routeData.argsAs<ObddtarouterArgs>();
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.OBDdata(
          key: args.key,
          obd2: args.obd2,
          turnOBD_OFF: args.turnOBD_OFF,
          logic: args.help,
        ),
      );
    },
    Historyrouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.HistoryUser(),
      );
    },
    Riderouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.Ride(),
      );
    },
    Confrouter.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ConfigurePage(),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/app',
          fullMatch: true,
        ),
        _i7.RouteConfig(
          Initialrouter.name,
          path: '/initial',
          children: [
            _i7.RouteConfig(
              Historyrouter.name,
              path: 'history',
              parent: Initialrouter.name,
            ),
            _i7.RouteConfig(
              Riderouter.name,
              path: 'ride',
              parent: Initialrouter.name,
            ),
            _i7.RouteConfig(
              Confrouter.name,
              path: 'conf',
              parent: Initialrouter.name,
            ),
          ],
        ),
        _i7.RouteConfig(
          Apploadingrouter.name,
          path: '/app',
        ),
        _i7.RouteConfig(
          Obddtarouter.name,
          path: '/obddta:obd2',
        ),
      ];
}

/// generated route for
/// [_i1.appMain]
class Initialrouter extends _i7.PageRouteInfo<InitialrouterArgs> {
  Initialrouter({
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          Initialrouter.name,
          path: '/initial',
          args: InitialrouterArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'Initialrouter';
}

class InitialrouterArgs {
  const InitialrouterArgs({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return 'InitialrouterArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.Loadingpage]
class Apploadingrouter extends _i7.PageRouteInfo<void> {
  const Apploadingrouter()
      : super(
          Apploadingrouter.name,
          path: '/app',
        );

  static const String name = 'Apploadingrouter';
}

/// generated route for
/// [_i3.OBDdata]
class Obddtarouter extends _i7.PageRouteInfo<ObddtarouterArgs> {
  Obddtarouter({
    _i8.Key? key,
    required _i9.ObdPlugin obd2,
    required dynamic Function() turnOBD_OFF,
    required bool help,
  }) : super(
          Obddtarouter.name,
          path: '/obddta:obd2',
          args: ObddtarouterArgs(
            key: key,
            obd2: obd2,
            turnOBD_OFF: turnOBD_OFF,
            help: help,
          ),
        );

  static const String name = 'Obddtarouter';
}

class ObddtarouterArgs {
  const ObddtarouterArgs({
    this.key,
    required this.obd2,
    required this.turnOBD_OFF,
    required this.help,
  });

  final _i8.Key? key;

  final _i9.ObdPlugin obd2;

  final dynamic Function() turnOBD_OFF;

  final bool help;

  @override
  String toString() {
    return 'ObddtarouterArgs{key: $key, obd2: $obd2, turnOBD_OFF: $turnOBD_OFF, help: $help}';
  }
}

/// generated route for
/// [_i4.HistoryUser]
class Historyrouter extends _i7.PageRouteInfo<void> {
  const Historyrouter()
      : super(
          Historyrouter.name,
          path: 'history',
        );

  static const String name = 'Historyrouter';
}

/// generated route for
/// [_i5.Ride]
class Riderouter extends _i7.PageRouteInfo<void> {
  const Riderouter()
      : super(
          Riderouter.name,
          path: 'ride',
        );

  static const String name = 'Riderouter';
}

/// generated route for
/// [_i6.ConfigurePage]
class Confrouter extends _i7.PageRouteInfo<void> {
  const Confrouter()
      : super(
          Confrouter.name,
          path: 'conf',
        );

  static const String name = 'Confrouter';
}
