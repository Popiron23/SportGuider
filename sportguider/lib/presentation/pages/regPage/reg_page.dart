import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/data/models/account_model.dart';
import 'package:sportguider/database_service.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/auth_button.dart';
import 'package:sportguider/presentation/pages/authPage/widgets/password_input_field.dart';
import 'package:sportguider/presentation/pages/profile/profile_role_storage.dart';
import 'package:sportguider/presentation/pages/regPage/widgets/login_input_field.dart';
import 'package:sportguider/presentation/widgets/back_button.dart';
import 'package:sportguider/routes/router.gr.dart';
import 'package:toggle_switch/toggle_switch.dart';

@RoutePage()
class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  DatabaseService databaseService = DatabaseService();
  int _selectedRoleIndex = 1;

  Role get _selectedRole => _selectedRoleIndex == 0 ? Role.coach : Role.user;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _openProfile(AccountEntity account) async {
    await ProfileRoleStorage.saveRole(_selectedRole);
    Map<String, dynamic> data = {
      'id': account.id,
      'email': account.email,
      'name': account.name,
      'phoneNumber': account.phoneNumber,
      'role': _selectedRole == Role.coach ? "coach" : "user",
      'favoriteSport': account.favoriteSport,
    };

    String path = _selectedRole == Role.coach ? 'Coaches' : 'Users';
    await databaseService.create(path: '$path/${account.id}', data: data);

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
              'Регистрация',
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
              child: LoginInputField(controller: emailController),
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
            ToggleSwitch(
              minWidth: 200,
              initialLabelIndex: _selectedRoleIndex,
              totalSwitches: 2,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              activeBgColor: [
                AppColors.activeColor,
                AppColors.activeColor,
                AppColors.activeColor,
              ],
              labels: const ['Тренер', 'Спортсмен'],
              onToggle: (index) {
                setState(() {
                  _selectedRoleIndex = index ?? 1;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 320,
              height: 35,
              child: AuthButton(
                title: 'Зарегистрироваться',
                onPressed: () async {
                  final email = emailController.text;
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

                  final result = await FirebaseService.onRegister(
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
                    SnackBar(
                      content: Text(errorMessage ?? 'Ошибка регистрации'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
