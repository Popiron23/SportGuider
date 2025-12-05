import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoachFilterButton extends StatelessWidget {
  const CoachFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Действие при нажатии
        print('Кнопка нажата!');
      },
      backgroundColor: AppColors.activeColor,
      shape: CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/svg/filter.svg',
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
