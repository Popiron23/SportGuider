import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/data/models/account_model.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/profile/profile_role_storage.dart';
import 'package:sportguider/routes/router.gr.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final user = FirebaseService.auth.currentUser;

        if (user == null) {
          context.router.push(const AuthRoute());
          return;
        }

        final savedRole = await ProfileRoleStorage.readRole();
        final account = AccountEntity.fromModel(
          AccountModel.fromFirebaseUser(user),
        ).copyWith(role: savedRole);

        if (!context.mounted) {
          return;
        }

        if (savedRole == Role.coach) {
          context.router.push(CoachProfileRoute(account: account));
          return;
        }

        context.router.push(UserProfileRoute(account: account));
      },
      backgroundColor: Colors.white,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/svg/profile-round.svg',
        colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
      ),
    );
  }
}
