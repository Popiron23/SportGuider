import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

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
        'assets/images/search.svg',
        colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
      ),
    );
  }
}
