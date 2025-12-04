import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/username_input_field.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/password_input_field.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/auth_button.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 60, right: 60, top: 325),
            child: Column(
              children: [
                //Отступ между виджетом "Логин" и текстом "Регистрация"
                SizedBox(height: 60),

                //Виджет-логин
                Container(width: 320, height: 35, child: UsernameInputField()),

                //Отступ между виджетом "Пароль" и виджетом "Логин"
                SizedBox(height: 70),

                //Виджет-пароль
                Container(width: 320, height: 35, child: PasswordInputField()),

                //Отступ между виджетом "Пароль" и виджетом "Зарегистрироваться"
                SizedBox(height: 30),

                //Виджет-зарегистрироваться
                Container(width: 320, height: 35, child: AuthButton()),
              ],
            ),
          ),

          //Текст "Регистрация"
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Авторизация',
                style: GoogleFonts.philosopher(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.activeColor,
                ),
              ),
            ),
          ),

          //Текст "Логин"
          Positioned(
            top: 356,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Логин',
                style: GoogleFonts.philosopher(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.activeColor,
                ),
              ),
            ),
          ),

          //Текст "Пароль"
          Positioned(
            top: 460,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Пароль',
                style: GoogleFonts.philosopher(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.activeColor,
                ),
              ),
            ),
          ),

          //Стрелочка-возвращение назад
          Padding(
            padding: EdgeInsets.all(10), // Отступ со всех сторон
            child: IconButton.filled(
              onPressed: () {
                // Действие при нажатии
                print('Кнопка нажата!');
              },
              icon: SvgPicture.asset(
                Icons.arrow_back as String,
                colorFilter: ColorFilter.mode(
                  AppColors.activeColor,
                  BlendMode.srcIn,
                ),
              ),
              iconSize: 50,
              color: AppColors.activeColor,
              style: IconButton.styleFrom(backgroundColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
