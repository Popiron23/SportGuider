import 'package:flutter/material.dart';
//import 'package:sportguider/presentation/colors.dart';

class LoginInputField extends StatefulWidget
{
  const LoginInputField({super.key});
  @override
  State<LoginInputField> createState()=>_LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField>
{
  @override
  Widget build(BuildContext context)
  {
    return TextField(
          decoration:InputDecoration(
          border:OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: 'Введите логин',
          hintStyle: TextStyle(color:const Color.fromARGB(255,135,135,135)),
          fillColor: const Color.fromARGB(255, 214, 213, 213),
          contentPadding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
          ),
          filled:true,
          ),
        );
  }
}