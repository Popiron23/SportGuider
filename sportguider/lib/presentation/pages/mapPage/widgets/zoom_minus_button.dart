import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ZoomMinusButton extends StatelessWidget {
  const ZoomMinusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Действие при нажатии
        print('Кнопка нажата!');
      },
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.remove, color: AppColors.activeColor, size: 30),
    );
  }
}
