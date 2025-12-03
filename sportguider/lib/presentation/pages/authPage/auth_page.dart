import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/username_stroke.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/password_stroke.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [UsernameStroke(), PasswordStroke()],
        ),
      ),
    );
  }
}
