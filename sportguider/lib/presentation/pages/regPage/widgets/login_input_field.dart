import 'package:flutter/material.dart';
//import 'package:sportguider/presentation/colors.dart';

class LoginInputField extends StatefulWidget {
  final TextEditingController controller;
  const LoginInputField({super.key, required this.controller});
  @override
  State<LoginInputField> createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Введите email',
        hintStyle: TextStyle(color: const Color.fromARGB(255, 135, 135, 135)),
        fillColor: const Color.fromARGB(255, 214, 213, 213),
        contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        filled: true,
      ),
    );
  }
}
