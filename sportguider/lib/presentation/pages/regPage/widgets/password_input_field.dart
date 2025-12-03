import 'package:flutter/material.dart';
//import 'package:sportguider/presentation/colors.dart';

class PasswordInputField extends StatefulWidget
{
  const PasswordInputField({super.key});
  @override
  State<PasswordInputField> createState()=>_PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField>
{
  @override
  Widget build(BuildContext context)
  {
    return TextField(
          decoration:InputDecoration(
          border:OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: 'Введите пароль',
          hintStyle: TextStyle(color:const Color.fromARGB(255,135,135,135)),
          fillColor: const Color.fromARGB(255, 184, 184,184),
          contentPadding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
          ),
          filled:true,
          ),
        );
  }
}