import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';

class ZoomPlusButton extends StatelessWidget {
  const ZoomPlusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Действие при нажатии
        print('Кнопка нажата!');
      },
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.add, color: AppColors.activeColor, size: 30),
    );
  }
}
