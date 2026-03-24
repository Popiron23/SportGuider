import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/profile/profile_role_storage.dart';
import 'package:sportguider/presentation/pages/profile/widgets/profile_shell.dart';
import 'package:sportguider/routes/router.gr.dart';

@RoutePage()
class UserProfilePage extends StatelessWidget {
  final AccountEntity account;

  const UserProfilePage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final coaches = account.coaches
        .where((coach) => coach.trim().isNotEmpty)
        .toList();
    final favoriteSport = account.favoriteSport?.trim().isNotEmpty == true
        ? account.favoriteSport!.trim()
        : 'В поиске любимого спорта';

    return ProfileShell(
      account: account,
      roleLabel: 'ПРОФИЛЬ СПОРТСМЕНА',
      headline: 'Личный кабинет для тренировок, маршрутов и общения с тренерами.',
      description:
          'Экран построен как живой профиль участника: крупный акцент на личности, спортивной цели и быстрых действиях.',
      editTitle: 'Редактирование профиля спортсмена',
      editButtonLabel: 'Редактировать профиль',
      activityBadge: 'В форме',
      accentColor: AppColors.activeColor,
      secondaryAccentColor: AppColors.activeDarkColor,
      metrics: [
        ProfileMetric(
          icon: Icons.sports_basketball_rounded,
          label: 'Любимый спорт',
          value: favoriteSport,
          accentColor: AppColors.activeColor,
        ),
        ProfileMetric(
          icon: Icons.groups_rounded,
          label: 'Тренеров рядом',
          value: coaches.length.toString().padLeft(2, '0'),
          accentColor: AppColors.successColor,
        ),
        ProfileMetric(
          icon: Icons.track_changes_rounded,
          label: 'Статус',
          value: 'Активен',
          accentColor: AppColors.warningColor,
        ),
      ],
      editOptions: const [
        ProfileEditOption(
          icon: Icons.person_outline_rounded,
          title: 'Фото и имя',
          subtitle: 'Обновить аватар, отображаемое имя и короткое описание.',
        ),
        ProfileEditOption(
          icon: Icons.contact_mail_outlined,
          title: 'Контакты',
          subtitle: 'Почта, телефон и предпочтительный способ связи.',
        ),
        ProfileEditOption(
          icon: Icons.fitness_center_rounded,
          title: 'Спортивные данные',
          subtitle: 'Любимый спорт, цели тренировок и текущий фокус.',
        ),
      ],
      sections: [
        ProfileSectionCard(
          title: 'Контакты',
          subtitle: 'Базовая информация, чтобы быстро связаться или узнать чей это профиль.',
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'E-mail',
                value: _displayValue(account.email, 'Добавьте почту для связи'),
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.phone_outlined,
                label: 'Телефон',
                value: _displayValue(
                  account.phoneNumber,
                  'Телефон пока не указан',
                ),
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.badge_outlined,
                label: 'ID профиля',
                value: account.id,
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Спортивный фокус',
          subtitle: 'Блок можно использовать как быстрый срез по текущему настрою и интересам пользователя.',
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.local_fire_department_outlined,
                label: 'Основной интерес',
                value: favoriteSport,
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.flag_outlined,
                label: 'Текущая цель',
                value: 'Найти подходящего тренера и выстроить удобный ритм занятий.',
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ProfileTag(
                    text: favoriteSport,
                    color: AppColors.activeColor,
                  ),
                  ProfileTag(
                    text: 'Маршруты',
                    color: AppColors.successColor,
                  ),
                  ProfileTag(
                    text: 'Новые тренировки',
                    color: AppColors.warningColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Мои тренеры',
          subtitle: 'Здесь органично смотрится список специалистов, которых пользователь уже добавил или с кем занимается.',
          child: coaches.isEmpty
              ? const ProfileEmptyState(
                  title: 'Пока пусто',
                  subtitle:
                      'Когда пользователь выберет тренера, его карточка или имя могут появляться прямо в этом блоке.',
                )
              : Column(
                  children: coaches
                      .map(
                        (coach) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.softBlueColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.emoji_events_outlined,
                                    color: AppColors.activeColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    coach,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
      onLogout: (context) async {
        await FirebaseService().logOut();
        await ProfileRoleStorage.clear();
        if (context.mounted) {
          context.router.replace(const AuthRoute());
        }
      },
    );
  }

  static String _displayValue(String? value, String fallback) {
    if (value == null || value.trim().isEmpty || value.trim() == 'null') {
      return fallback;
    }

    return value.trim();
  }
}
