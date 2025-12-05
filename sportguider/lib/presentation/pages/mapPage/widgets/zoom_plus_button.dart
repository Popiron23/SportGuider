import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';

class ZoomPlusButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ZoomPlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.add, color: AppColors.activeColor, size: 30),
    );
  }
}
