import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/widgets/back_button.dart';

@RoutePage()
class UserProfilePage extends StatefulWidget {
  final AccountEntity account;
  const UserProfilePage({super.key, required this.account});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text('Профиль'),
      leading: BackButtonReg(),
      backgroundColor: Colors.white,
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            child: SvgPicture.asset(
              'assets/images/svg/profile-round.svg',
              width: 50,
              height: 50,
              colorFilter: ColorFilter.mode(
                AppColors.activeColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(children: [Text('Имя: '), Text(widget.account.name ?? '')]),
        const SizedBox(height: 30),
        Row(
          children: [
            Text('Вид спорта: '),
            Text(widget.account.favoriteSport ?? ''),
          ],
        ),
        const SizedBox(height: 30),
        Row(children: [Text('E-mail: '), Text(widget.account.email ?? '')]),
        const SizedBox(height: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тренеры: '),
            ...widget.account.coaches.map((e) => Text(e)),
          ],
        ),
      ],
    ),
  );
}
