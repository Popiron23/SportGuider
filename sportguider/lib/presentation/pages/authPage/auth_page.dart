import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/text_reg_button.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/username_input_field.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/password_input_field.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/auth_button.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/presentation/widgets/back_button.dart';
import 'package:sportguider/routes/router.gr.dart';
import 'package:toggle_switch/toggle_switch.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final TextEditingController usernameController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButtonReg(), backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 60, right: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Авторизация',
              style: GoogleFonts.philosopher(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.activeColor,
              ),
            ),
            //Отступ между виджетом "Логин" и текстом "Регистрация"
            SizedBox(height: 60),
            Text(
              'Логин',
              style: GoogleFonts.philosopher(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.activeColor,
              ),
            ),
            //Виджет-логин
            Container(
              width: 320,
              height: 35,
              child: UsernameInputField(controller: usernameController),
            ),
            //Отступ между виджетом "Пароль" и виджетом "Логин"
            SizedBox(height: 30),
            Text(
              'Пароль',
              style: GoogleFonts.philosopher(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.activeColor,
              ),
            ),
            //Виджет-пароль
            Container(
              width: 320,
              height: 35,
              child: PasswordInputField(controller: passwordController),
            ),

            //Отступ между виджетом "Пароль" и виджетом "Зарегистрироваться"
            SizedBox(height: 30),
            // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
            ToggleSwitch(
              minWidth: 200,
              initialLabelIndex: 0,
              totalSwitches: 2,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              activeBgColor: [
                AppColors.activeColor,
                AppColors.activeColor,
                AppColors.activeColor,
              ],
              labels: ['Тренер', 'Спортсмен'],
              onToggle: (index) {
                print('switched to: $index');
              },
            ),
            SizedBox(height: 30),
            //Виджет-зарегистрироваться
            Container(
              width: 320,
              height: 35,
              child: AuthButton(
                title: 'Войти',
                onPressed: () {
                  final name = usernameController.text;
                  final password = passwordController.text;
                  if (name == 'admin' && password == 'admin') {
                    context.router.replace(
                      UserProfileRoute(
                        account: AccountEntity(
                          id: 1,
                          name: 'Иванов Иван',
                          email: 'example@mail.com',
                          phoneNumber: '+7900123123',
                          favoriteSport: 'Баскетбол',
                          coaches: ['Петров Петр Петрович'],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            TextRegButton(),
          ],
        ),
      ),
    );
  }
}
