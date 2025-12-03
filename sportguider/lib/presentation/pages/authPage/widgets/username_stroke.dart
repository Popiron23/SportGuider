import 'package:flutter/material.dart';
//import 'package:sportguider/presentation/colors.dart';

class UsernameStroke extends StatefulWidget {
  const UsernameStroke({super.key});

  @override
  State<UsernameStroke> createState() => _UsernameStrokeState();
}

class _UsernameStrokeState extends State<UsernameStroke> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: 'Введите имя пользователя',
          hintStyle: TextStyle(color: const Color.fromARGB(255, 135, 135, 135)),
          helperText: 'Введите имя что указывали при регистрации',
          fillColor: const Color.fromARGB(255, 184, 184, 184),
          filled: true,
        ),
      ),
    );
  }
}
