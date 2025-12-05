import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
//import 'package:sportguider/presentation/colors.dart';

class AuthButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  const AuthButton({super.key, required this.onPressed, required this.title});
  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.activeColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
