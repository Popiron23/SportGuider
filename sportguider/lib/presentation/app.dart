import 'package:flutter/material.dart';
//import 'package:sportguider/domain/entities/location_entity.dart';
//import 'package:sportguider/presentation/pages/mapPage/map_page.dart';
import 'package:sportguider/routes/router.dart';
import 'package:sportguider/presentation/pages/authPage/auth_page.dart';
import 'package:sportguider/presentation/pages/regPage/reg_page.dart';
import 'package:sportguider/presentation/pages/CoachPage/coach_page.dart';
import 'package:sportguider/presentation/pages/splashScreen/splash_page.dart';

class SportGuiderApp extends StatefulWidget {
  const SportGuiderApp({super.key});

  @override
  State<SportGuiderApp> createState() => _SportGuiderAppState();
}

class _SportGuiderAppState extends State<SportGuiderApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
    ); //.router(routerConfig: _appRouter.config());
  }
}
