import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';

class ZoomMinusButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ZoomMinusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.remove, color: AppColors.activeColor, size: 30),
    );
  }
}
