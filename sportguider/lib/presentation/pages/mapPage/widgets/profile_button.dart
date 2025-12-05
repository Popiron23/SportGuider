import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/routes/router.gr.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.router.push(const AuthRoute());
      },
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/svg/profile-round.svg',
        colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
      ),
    );
  }
}
