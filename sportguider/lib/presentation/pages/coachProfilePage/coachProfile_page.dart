import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/profile/profile_role_storage.dart';
import 'package:sportguider/presentation/pages/profile/widgets/profile_shell.dart';
import 'package:sportguider/routes/router.gr.dart';

@RoutePage()
class CoachProfilePage extends StatelessWidget {
  final AccountEntity account;

  const CoachProfilePage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final specialization = account.favoriteSport?.trim().isNotEmpty == true
        ? account.favoriteSport!.trim()
        : 'Функциональная подготовка';

    return ProfileShell(
      account: account,
      roleLabel: 'ПРОФИЛЬ ТРЕНЕРА',
      headline: 'Витрина тренера с акцентом на экспертность, формат работы и доверие.',
      description:
          'Этот экран выглядит более статусно: он продаёт специалиста, помогает ученику быстро понять сильные стороны и подводит к записи.',
      editTitle: 'Редактирование профиля тренера',
      editButtonLabel: 'Настроить витрину',
      activityBadge: 'Открыт к заявкам',
      accentColor: const Color(0xFF2F71F7),
      secondaryAccentColor: const Color(0xFF1D9A9D),
      metrics: [
        ProfileMetric(
          icon: Icons.workspace_premium_rounded,
          label: 'Роль',
          value: 'Тренер',
          accentColor: const Color(0xFF2F71F7),
        ),
        ProfileMetric(
          icon: Icons.sports_score_rounded,
          label: 'Направление',
          value: specialization,
          accentColor: AppColors.successColor,
        ),
        ProfileMetric(
          icon: Icons.calendar_month_rounded,
          label: 'Формат',
          value: 'Инд. / группы',
          accentColor: AppColors.warningColor,
        ),
      ],
      editOptions: const [
        ProfileEditOption(
          icon: Icons.style_outlined,
          title: 'Витрина тренера',
          subtitle:
              'Фото, имя, короткий слоган и первое впечатление на экране.',
        ),
        ProfileEditOption(
          icon: Icons.military_tech_outlined,
          title: 'Специализация',
          subtitle:
              'Направления подготовки, спортивные акценты и достижения.',
        ),
        ProfileEditOption(
          icon: Icons.schedule_outlined,
          title: 'Формат работы',
          subtitle:
              'Индивидуально, группы, онлайн, офлайн и доступность для записи.',
        ),
      ],
      sections: [
        ProfileSectionCard(
          title: 'О тренере',
          subtitle:
              'Карточка задаёт спокойный, уверенный тон и помогает быстро считать позиционирование.',
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.sports_gymnastics_rounded,
                label: 'Специализация',
                value: specialization,
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.auto_awesome_outlined,
                label: 'Подход',
                value:
                    'Структурные тренировки с понятным прогрессом и мягким сопровождением.',
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'Контакт для записи',
                value: _displayValue(account.email, 'Почта для записи появится здесь'),
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Сильные стороны',
          subtitle:
              'Здесь хорошо смотрятся короткие компетенции, которые помогают ученику быстро принять решение.',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ProfileTag(
                text: specialization,
                color: const Color(0xFF2F71F7),
              ),
              ProfileTag(
                text: 'Персональный план',
                color: AppColors.successColor,
              ),
              ProfileTag(
                text: 'Техника и контроль',
                color: AppColors.warningColor,
              ),
              ProfileTag(
                text: 'Поддержка новичков',
                color: AppColors.dangerColor,
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Что получает ученик',
          subtitle:
              'Небольшой продающий блок, который можно потом расширить отзывами или слотами расписания.',
          child: Column(
            children: const [
              _CoachBenefitTile(
                icon: Icons.route_rounded,
                title: 'Понятный маршрут развития',
                subtitle:
                    'От первой встречи до устойчивого тренировочного ритма без хаоса.',
              ),
              SizedBox(height: 14),
              _CoachBenefitTile(
                icon: Icons.checklist_rtl_rounded,
                title: 'Собранная структура занятий',
                subtitle:
                    'Тренерский профиль сразу показывает, как выстроена работа и чего ждать.',
              ),
              SizedBox(height: 14),
              _CoachBenefitTile(
                icon: Icons.favorite_border_rounded,
                title: 'Человечная коммуникация',
                subtitle:
                    'Профиль выглядит дружелюбно и вызывает доверие ещё до первого сообщения.',
              ),
            ],
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

class _CoachBenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CoachBenefitTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF2F71F7)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
