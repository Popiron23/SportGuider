import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/presentation/colors.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.activeColor,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/svg/search.svg',
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
