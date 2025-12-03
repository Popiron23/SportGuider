import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/presentation/pages/regPage/widgets/password_input_field.dart';
import 'package:sportguider/presentation/pages/regPage/widgets/login_input_field.dart';
@RoutePage()
class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 60,
          right: 60,
          top: 325,
        ),
        child: Column(
          children: [
            //Виджет-логин
            Container(
              width: 320,
              height: 35,
              child: LoginInputField(),
            ),
            
            SizedBox(height: 100), //Отступ между виджетами
            
            // Виджет-пароль
            Container(
              width: 320,
              height: 35,
              child: PasswordInputField(),
            ),
          ],
        ),
      ),
    );
  }
}
