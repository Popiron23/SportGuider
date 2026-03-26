import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/data/models/account_model.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/auth_button.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/password_input_field.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/text_reg_button.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/username_input_field.dart';
import 'package:sportguider/presentation/pages/profile/profile_role_storage.dart';
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
  int _selectedRoleIndex = 1;

  Role get _selectedRole => _selectedRoleIndex == 0 ? Role.coach : Role.user;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _openProfile(AccountEntity account) async {
    await ProfileRoleStorage.saveRole(_selectedRole);

    if (!mounted) {
      return;
    }

    if (_selectedRole == Role.coach) {
      context.router.replace(CoachProfileRoute(account: account));
      return;
    }

    context.router.replace(UserProfileRoute(account: account));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonReg(),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
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
            const SizedBox(height: 60),
            Text(
              'Логин',
              style: GoogleFonts.philosopher(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.activeColor,
              ),
            ),
            SizedBox(
              width: 320,
              height: 35,
              child: UsernameInputField(controller: usernameController),
            ),
            const SizedBox(height: 30),
            Text(
              'Пароль',
              style: GoogleFonts.philosopher(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.activeColor,
              ),
            ),
            SizedBox(
              width: 320,
              height: 35,
              child: PasswordInputField(controller: passwordController),
            ),
            const SizedBox(height: 30),
            // ToggleSwitch(
            //   minWidth: 200,
            //   initialLabelIndex: _selectedRoleIndex,
            //   totalSwitches: 2,
            //   activeFgColor: Colors.white,
            //   inactiveBgColor: Colors.white,
            //   activeBgColor: [
            //     AppColors.activeColor,
            //     AppColors.activeColor,
            //     AppColors.activeColor,
            //   ],
            //   labels: const ['Тренер', 'Спортсмен'],
            //   onToggle: (index) {
            //     setState(() {
            //       _selectedRoleIndex = index ?? 1;
            //     });
            //   },
            // ),
            const SizedBox(height: 30),
            SizedBox(
              width: 320,
              height: 35,
              child: AuthButton(
                title: 'Войти',
                onPressed: () async {
                  final email = usernameController.text;
                  final password = passwordController.text;
                  String? errorMessage;

                  if (email == 'admin' && password == 'admin') {
                    await _openProfile(
                      AccountEntity(
                        id: '1',
                        name: 'Иванов Иван',
                        email: 'example@mail.com',
                        phoneNumber: '+7900123123',
                        role: _selectedRole,
                        favoriteSport: 'Баскетбол',
                        coaches: const ['Петров Петр Петрович'],
                      ),
                    );
                    return;
                  }

                  final result = await FirebaseService.onLogin(
                    email: email,
                    password: password,
                  );

                  if (result != null && result.isSuccess) {
                    await _openProfile(
                      AccountEntity.fromModel(
                        AccountModel.fromFirebaseUser(result.credential!.user),
                      ).copyWith(role: _selectedRole),
                    );
                    return;
                  }

                  errorMessage = result?.errorMes;
                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage ?? 'Ошибка входа')),
                  );
                },
              ),
            ),
            const TextRegButton(),
          ],
        ),
      ),
    );
  }
}
