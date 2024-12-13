// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'autoroute.dart';

/// generated route for
/// [appmain]
class Appmain extends PageRouteInfo<AppmainArgs> {
  Appmain({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          Appmain.name,
          args: AppmainArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'Appmain';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppmainArgs>(orElse: () => const AppmainArgs());
      return appmain(key: args.key);
    },
  );
}

class AppmainArgs {
  const AppmainArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'AppmainArgs{key: $key}';
  }
}

/// generated route for
/// [configurepage]
class Configurepage extends PageRouteInfo<void> {
  const Configurepage({List<PageRouteInfo>? children})
      : super(
          Configurepage.name,
          initialChildren: children,
        );

  static const String name = 'Configurepage';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const configurepage();
    },
  );
}

/// generated route for
/// [getallpids]
class Getallpids extends PageRouteInfo<void> {
  const Getallpids({List<PageRouteInfo>? children})
      : super(
          Getallpids.name,
          initialChildren: children,
        );

  static const String name = 'Getallpids';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const getallpids();
    },
  );
}

/// generated route for
/// [getselectpids]
class Getselectpids extends PageRouteInfo<void> {
  const Getselectpids({List<PageRouteInfo>? children})
      : super(
          Getselectpids.name,
          initialChildren: children,
        );

  static const String name = 'Getselectpids';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const getselectpids();
    },
  );
}

/// generated route for
/// [historyuser]
class Historyuser extends PageRouteInfo<void> {
  const Historyuser({List<PageRouteInfo>? children})
      : super(
          Historyuser.name,
          initialChildren: children,
        );

  static const String name = 'Historyuser';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const historyuser();
    },
  );
}

/// generated route for
/// [loadingpage]
class Loadingpage extends PageRouteInfo<void> {
  const Loadingpage({List<PageRouteInfo>? children})
      : super(
          Loadingpage.name,
          initialChildren: children,
        );

  static const String name = 'Loadingpage';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const loadingpage();
    },
  );
}

/// generated route for
/// [obddata]
class Obddata extends PageRouteInfo<ObddataArgs> {
  Obddata({
    Key? key,
    required ObdPlugin obd2,
    required bool logic,
    List<PageRouteInfo>? children,
  }) : super(
          Obddata.name,
          args: ObddataArgs(
            key: key,
            obd2: obd2,
            logic: logic,
          ),
          initialChildren: children,
        );

  static const String name = 'Obddata';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ObddataArgs>();
      return obddata(
        key: args.key,
        obd2: args.obd2,
        logic: args.logic,
      );
    },
  );
}

class ObddataArgs {
  const ObddataArgs({
    this.key,
    required this.obd2,
    required this.logic,
  });

  final Key? key;

  final ObdPlugin obd2;

  final bool logic;

  @override
  String toString() {
    return 'ObddataArgs{key: $key, obd2: $obd2, logic: $logic}';
  }
}

/// generated route for
/// [pidsdiscovery]
class Pidsdiscovery extends PageRouteInfo<void> {
  const Pidsdiscovery({List<PageRouteInfo>? children})
      : super(
          Pidsdiscovery.name,
          initialChildren: children,
        );

  static const String name = 'Pidsdiscovery';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const pidsdiscovery();
    },
  );
}

/// generated route for
/// [ride]
class Ride extends PageRouteInfo<void> {
  const Ride({List<PageRouteInfo>? children})
      : super(
          Ride.name,
          initialChildren: children,
        );

  static const String name = 'Ride';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ride();
    },
  );
}
