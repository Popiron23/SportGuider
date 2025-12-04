import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
//import 'package:sportguider/presentation/colors.dart';

class RegistrationButton extends StatefulWidget
{
  const RegistrationButton({super.key});
  @override
  State<RegistrationButton> createState()=>_RegistrationButtonState();
}

class _RegistrationButtonState extends State<RegistrationButton> {
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
          'Зарегистрироваться',
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