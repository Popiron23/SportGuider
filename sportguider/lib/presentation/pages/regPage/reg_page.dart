import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/presentation/pages/regPage/widgets/password_input_field.dart';
import 'package:sportguider/presentation/pages/regPage/widgets/login_input_field.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 60,
              right: 60,
              top: 325,
            ),
            child: Column(
              children: [

                SizedBox(height: 60),

                //Виджет-логин
                Container(
                  width: 320,
                  height: 35,
                  child: LoginInputField(),
                ),
                
                SizedBox(height: 100),
                
                //Виджет-пароль
                Container(
                  width: 320,
                  height: 35,
                  child: PasswordInputField(),
                ),
              ],
            ),
          ),
          
          //Надпись "Регистрация"
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Регистрация',
                style: GoogleFonts.philosopher(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.activeColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
