import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/presentation/colors.dart';

class GeolocationButton extends StatelessWidget {
  const GeolocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Действие при нажатии
        print('Кнопка нажата!');
      },
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/navigation.svg',
        colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
      ),
    );
  }
}
