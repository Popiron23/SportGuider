import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
//import 'package:sportguider/presentation/colors.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({super.key});
  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.activeColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Войти',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
