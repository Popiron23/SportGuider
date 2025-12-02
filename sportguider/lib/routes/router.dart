import 'package:auto_route/auto_route.dart';
import 'package:sportguider/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/home',
      page: HomeRoute.page,
      initial: true,
      children: [
        AutoRoute(path: 'map', page: MapRoute.page),
        AutoRoute(path: 'reg', page: RegRoute.page),
        AutoRoute(path: 'friend', page: FriendRoute.page),
      ],
    ),
  ];
}
