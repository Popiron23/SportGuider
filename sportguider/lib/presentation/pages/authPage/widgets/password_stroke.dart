import 'package:flutter/material.dart';
//import 'package:sportguider/presentation/colors.dart';

class PasswordStroke extends StatefulWidget {
  const PasswordStroke({super.key});

  @override
  State<PasswordStroke> createState() => _PasswordStrokeState();
}

class _PasswordStrokeState extends State<PasswordStroke> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Введите пароль',
        hintStyle: TextStyle(color: const Color.fromARGB(255, 135, 135, 135)),
        helperText: 'Введите пароль что указывали при регистрации',
        fillColor: const Color.fromARGB(255, 184, 184, 184),
        filled: true,
      ),
    );
  }
}
