import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportguider/data/models/account_model.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/routes/router.gr.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        FirebaseService.OnListenUser((user) {
          if (user == null) {
            context.router.push(const AuthRoute());
          } else {
            context.router.push(
              UserProfileRoute(
                account: AccountEntity.fromModel(
                  AccountModel.fromFirebaseUser(user),
                ),
              ),
            );
          }
        });
      },
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: SvgPicture.asset(
        'assets/images/svg/profile-round.svg',
        colorFilter: ColorFilter.mode(AppColors.activeColor, BlendMode.srcIn),
      ),
    );
  }
}
