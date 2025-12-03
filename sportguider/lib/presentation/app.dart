import 'package:flutter/material.dart';
import 'package:sportguider/routes/router.dart';
import 'package:sportguider/presentation/pages/authPage/auth_page.dart';

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
      home: AuthPage(),
    ); //.router(routerConfig: _appRouter.config());
  }
}
