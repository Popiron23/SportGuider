import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/routes/router.gr.dart';

class TextRegButton extends StatefulWidget {
  const TextRegButton({super.key});

  @override
  State<TextRegButton> createState() => _TextRegButtonState();
}

class _TextRegButtonState extends State<TextRegButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Нет аккаунта?',
          style: TextStyle(color: AppColors.unactiveColor),
        ), // Текст "Нет аккаунта?"
        TextButton(
          onPressed: () {
            context.router.push(const RegRoute());
          },
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) return Colors.black;
              return AppColors.activeColor; // По умолчанию виджет.
            }),
          ),
          child: Text('Зарегистрироваться'),
        ),
      ],
    );
  }
}
