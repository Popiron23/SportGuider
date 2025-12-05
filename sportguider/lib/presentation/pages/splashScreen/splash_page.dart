import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'sportguider/assets/images/icon.svg',
          colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
        ),
        SpinKitCircle(color: Colors.blue, size: 50.0),
      ],
    );
  }
}
