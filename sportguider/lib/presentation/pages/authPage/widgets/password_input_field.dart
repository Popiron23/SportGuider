import 'package:flutter/material.dart';
//import 'package:sportguider/presentation/colors.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordInputField({super.key, required this.controller});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Введите пароль',
        hintStyle: TextStyle(color: const Color.fromARGB(255, 135, 135, 135)),
        fillColor: const Color.fromARGB(255, 214, 213, 213),
        contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        filled: true,
      ),
    );
  }
}
