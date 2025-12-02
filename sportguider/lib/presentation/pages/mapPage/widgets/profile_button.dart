import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileButton extends StatelessWidget {
  final String photo;

  const ProfileButton({super.key, this.photo = "assets\\images\\user.svg"});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(photo, width: 24.0, height: 24.0),
      onPressed: () {
        print('Кнопка нажата!');
      },
    );
  }
}
