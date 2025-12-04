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
      icon: SvgPicture.asset(
        'assets/images/profile-round.svg',
        colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(18),
      ),
    );
  }
}
