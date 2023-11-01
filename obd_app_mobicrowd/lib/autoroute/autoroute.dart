import 'package:auto_route/auto_route.dart';
import '../screens/loadingPage.dart';
import '../screens/OBDdatacollect.dart';
import '../screens/appMainPage.dart';
import '../screens/configurePage.dart';
import '../screens/loadingPage.dart';
import '../screens/riderObdUserPage.dart';
import '../screens/historyRiderUserPage.dart';
import '../widgets/appLoading.dart';
import '../widgets/obdDataBoxWidget.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        path: '/initial',
        name: 'initialrouter',
        page: appMain,
        children: [
          AutoRoute(
            path: 'history',
            name: 'historyrouter',
            page: HistoryUser,
          ),
          AutoRoute(path: 'ride', name: 'riderouter', page: Ride),
          AutoRoute(path: 'conf', name: 'confrouter', page: ConfigurePage),
        ]),
    AutoRoute(
      path: '/app',
      name: 'apploadingrouter',
      initial: true,
      page: Loadingpage,
    ),
    AutoRoute(
      path: '/obddta:obd2',
      name: 'obddtarouter',
      page: OBDdata,
    ),
  ],
)
class $AppRouter {}
