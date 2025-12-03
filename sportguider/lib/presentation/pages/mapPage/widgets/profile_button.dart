import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileButton extends StatefulWidget {
  final String photo;
  const ProfileButton({super.key, this.photo = "assets/images/user.svg"});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: IconButton(
        icon: SvgPicture.asset(widget.photo),
        onPressed: () {
          print('Кнопка нажата!');
        },
      ),
    );
  }
}
