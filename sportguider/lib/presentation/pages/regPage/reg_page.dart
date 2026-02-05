import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/data/models/account_model.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/text_reg_button.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/username_input_field.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/password_input_field.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/auth_button.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/presentation/pages/regPage/widgets/login_input_field.dart';
import 'package:sportguider/presentation/widgets/back_button.dart';
import 'package:sportguider/routes/router.gr.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';

@RoutePage()
class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  late final TextEditingController emailController = TextEditingController();
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
              'Регистрация',
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
              child: LoginInputField(controller: emailController),
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
                title: 'Зарегистрироваться',
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;
                  if (email == 'admin' && password == 'admin') {
                    context.router.replace(
                      UserProfileRoute(
                        account: AccountEntity(
                          id: '1',
                          name: 'Иванов Иван',
                          email: 'example@mail.com',
                          phoneNumber: '+7900123123',
                          favoriteSport: 'Баскетбол',
                          coaches: ['Петров Петр Петрович'],
                        ),
                      ),
                    );
                  } else {
                    final credential = await FirebaseService.onRegister(
                      email: email,
                      password: password,
                    );
                    context.router.replace(
                      //переходим на страницу с инфо о пользователе, передавая в аргументе accountEntity
                      //AccountEntity получаем из AccountModel преобразованием данных из firebase через специальный конструктор
                      UserProfileRoute(
                        account: AccountEntity.fromModel(
                          AccountModel.fromFirebaseUser(credential!.user),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
