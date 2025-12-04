import 'package:flutter/material.dart';
//import 'package:sportguider/presentation/colors.dart';

class UsernameInputField extends StatefulWidget {
  const UsernameInputField({super.key});

  @override
  State<UsernameInputField> createState() => _UsernameInputFieldState();
}

class _UsernameInputFieldState extends State<UsernameInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: 'Введите логин',
        hintStyle: TextStyle(color: const Color.fromARGB(255, 135, 135, 135)),
        fillColor: const Color.fromARGB(255, 214, 213, 213),
        contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        filled: true,
      ),
    );
  }
}
