import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
//import 'package:sportguider/presentation/colors.dart';

class BackButtonReg extends StatefulWidget {
  const BackButtonReg({super.key});

  @override
  State<BackButtonReg> createState() => _BackButtonRegState();
}

class _BackButtonRegState extends State<BackButtonReg> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.router.back();
      },
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.arrow_back, color: AppColors.activeColor),
    );
  }
}
