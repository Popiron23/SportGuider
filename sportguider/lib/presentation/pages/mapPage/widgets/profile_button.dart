import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/presentation/colors.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      iconSize: 75.0,
      onPressed: () {
        // Действие при нажатии
        print('Кнопка нажата!');
      },
      icon: Icon(Icons.account_circle_rounded, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.activeColor,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
