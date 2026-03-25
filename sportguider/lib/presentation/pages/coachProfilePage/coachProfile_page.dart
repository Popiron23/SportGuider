import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/profile/profile_customization_storage.dart';
import 'package:sportguider/presentation/pages/profile/profile_role_storage.dart';
import 'package:sportguider/presentation/pages/profile/widgets/profile_shell.dart';
import 'package:sportguider/routes/router.gr.dart';

@RoutePage()
class CoachProfilePage extends StatefulWidget {
  final AccountEntity account;

  const CoachProfilePage({super.key, required this.account});

  @override
  State<CoachProfilePage> createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage> {
  static const _defaultHeadline =
      'Витрина тренера с акцентом на экспертизу, формат работы и доверие.';
  static const _defaultDescription =
      'Этот экран выглядит более статусно: он продаёт специалиста, помогает ученику быстро понять сильные стороны и подводит к записи.';
  static const _defaultSportsAccents =
      'Техника движения, контроль нагрузки и уверенный прогресс.';
  static const _defaultAchievements =
      'Опыт работы с новичками и спортсменами, которым важна системность.';
  static const _defaultWorkFormat = 'Индивидуально и мини-группы';
  static const _defaultWorkMode = 'Онлайн и офлайн';
  static const _defaultAvailability = 'Открыт к новым заявкам';

  static const List<_CoachAvatarOption> _avatarOptions = [
    _CoachAvatarOption(
      Icons.workspace_premium_rounded,
      Color(0xFFEAF3FF),
      Color(0xFF2F71F7),
    ),
    _CoachAvatarOption(
      Icons.sports_gymnastics_rounded,
      Color(0xFFE9F7F1),
      Color(0xFF20A77B),
    ),
    _CoachAvatarOption(
      Icons.fitness_center_rounded,
      Color(0xFFFFF0E4),
      Color(0xFFFF9F45),
    ),
    _CoachAvatarOption(
      Icons.emoji_events_rounded,
      Color(0xFFFFF6DA),
      Color(0xFFE0A100),
    ),
    _CoachAvatarOption(
      Icons.flag_rounded,
      Color(0xFFE7F8FF),
      Color(0xFF21A7C9),
    ),
    _CoachAvatarOption(
      Icons.psychology_alt_rounded,
      Color(0xFFFFEEEC),
      Color(0xFFFF6E63),
    ),
  ];

  late String _displayName;
  late String _headline;
  late String _description;
  late String _specialization;
  late String _sportsAccents;
  late String _achievements;
  late String _workFormat;
  late String _workMode;
  late String _availability;
  int _avatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayName = _fallbackName(widget.account.name);
    _headline = _defaultHeadline;
    _description = _defaultDescription;
    _specialization = _specializationFallback(widget.account.favoriteSport);
    _sportsAccents = _defaultSportsAccents;
    _achievements = _defaultAchievements;
    _workFormat = _defaultWorkFormat;
    _workMode = _defaultWorkMode;
    _availability = _defaultAvailability;
    _loadCustomization();
  }

  Future<void> _loadCustomization() async {
    final customization = await ProfileCustomizationStorage.readCoachCustomization(
      widget.account.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      if (customization.displayName != null) {
        _displayName = _displayValue(
          customization.displayName!,
          _fallbackName(widget.account.name),
        );
      }
      if (customization.headline != null) {
        _headline = _displayValue(customization.headline!, _defaultHeadline);
      }
      if (customization.description != null) {
        _description = _displayValue(
          customization.description!,
          _defaultDescription,
        );
      }
      if (customization.avatarIndex != null) {
        _avatarIndex = customization.avatarIndex!
            .clamp(0, _avatarOptions.length - 1)
            .toInt();
      }
      if (customization.specialization != null) {
        _specialization = _displayValue(
          customization.specialization!,
          _specializationFallback(widget.account.favoriteSport),
        );
      }
      if (customization.sportsAccents != null) {
        _sportsAccents = _displayValue(
          customization.sportsAccents!,
          _defaultSportsAccents,
        );
      }
      if (customization.achievements != null) {
        _achievements = _displayValue(
          customization.achievements!,
          _defaultAchievements,
        );
      }
      if (customization.workFormat != null) {
        _workFormat = _displayValue(
          customization.workFormat!,
          _defaultWorkFormat,
        );
      }
      if (customization.workMode != null) {
        _workMode = _displayValue(
          customization.workMode!,
          _defaultWorkMode,
        );
      }
      if (customization.availability != null) {
        _availability = _displayValue(
          customization.availability!,
          _defaultAvailability,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final specialization = _displayValue(
      _specialization,
      _specializationFallback(widget.account.favoriteSport),
    );
    final sportsAccents = _displayValue(_sportsAccents, _defaultSportsAccents);
    final achievements = _displayValue(_achievements, _defaultAchievements);
    final workFormat = _displayValue(_workFormat, _defaultWorkFormat);
    final workMode = _displayValue(_workMode, _defaultWorkMode);
    final availability = _displayValue(_availability, _defaultAvailability);
    final specializationTags = _buildSpecializationTags(
      specialization: specialization,
      sportsAccents: sportsAccents,
      achievements: achievements,
    );

    return ProfileShell(
      account: widget.account.copyWith(
        name: _displayName,
        favoriteSport: specialization,
      ),
      roleLabel: 'ПРОФИЛЬ ТРЕНЕРА',
      headline: _displayValue(_headline, _defaultHeadline),
      description: _displayValue(_description, _defaultDescription),
      editTitle: 'Редактирование профиля тренера',
      editButtonLabel: 'Настроить витрину',
      activityBadge: 'Открыт к заявкам',
      accentColor: const Color(0xFF2F71F7),
      secondaryAccentColor: const Color(0xFF1D9A9D),
      avatar: _buildHeaderAvatar(),
      metrics: [
        const ProfileMetric(
          icon: Icons.workspace_premium_rounded,
          label: 'Роль',
          value: 'Тренер',
          accentColor: Color(0xFF2F71F7),
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
          value: workFormat,
          accentColor: AppColors.warningColor,
        ),
      ],
      editOptions: [
        ProfileEditOption(
          icon: Icons.style_outlined,
          title: 'Витрина тренера',
          subtitle:
              'Фото, имя, короткий слоган и первое впечатление на экране.',
          onTap: _openShowcaseEditor,
        ),
        ProfileEditOption(
          icon: Icons.military_tech_outlined,
          title: 'Специализация',
          subtitle:
              'Направления подготовки, спортивные акценты и достижения.',
          onTap: _openSpecializationEditor,
        ),
        ProfileEditOption(
          icon: Icons.schedule_outlined,
          title: 'Формат работы',
          subtitle:
              'Индивидуально, группы, онлайн, офлайн и доступность для записи.',
          onTap: _openWorkFormatEditor,
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
              const ProfileInfoRow(
                icon: Icons.auto_awesome_outlined,
                label: 'Подход',
                value:
                    'Структурные тренировки с понятным прогрессом и мягким сопровождением.',
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.groups_rounded,
                label: 'Формат занятий',
                value: workFormat,
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'Контакт для записи',
                value: _displayValue(
                  widget.account.email,
                  'Почта для записи появится здесь',
                ),
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Специализация',
          subtitle:
              'Здесь собраны направления подготовки, спортивные акценты и достижения, которые формируют образ тренера.',
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.tune_rounded,
                label: 'Спортивные акценты',
                value: sportsAccents,
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.emoji_events_outlined,
                label: 'Достижения',
                value: achievements,
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: specializationTags
                    .map(
                      (tag) => ProfileTag(
                        text: tag,
                        color: tag == specialization
                            ? const Color(0xFF2F71F7)
                            : AppColors.successColor,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Формат работы',
          subtitle:
              'Блок помогает быстро понять, как проходят занятия и насколько легко записаться на тренировку.',
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.calendar_month_rounded,
                label: 'Формат занятий',
                value: workFormat,
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.laptop_mac_rounded,
                label: 'Онлайн / офлайн',
                value: workMode,
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.event_available_rounded,
                label: 'Доступность для записи',
                value: availability,
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Что получает ученик',
          subtitle:
              'Небольшой продающий блок, который можно потом расширить отзывами или слотами расписания.',
          child: const Column(
            children: [
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

  Future<void> _openShowcaseEditor(BuildContext context) async {
    final result = await showModalBottomSheet<_CoachShowcaseEditorResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CoachShowcaseEditorSheet(
        avatarOptions: _avatarOptions,
        initialAvatarIndex: _avatarIndex,
        initialDisplayName: _displayName,
        initialHeadline: _headline == _defaultHeadline ? '' : _headline,
        initialDescription:
            _description == _defaultDescription ? '' : _description,
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _displayName = _displayValue(
        result.displayName,
        _fallbackName(widget.account.name),
      );
      _headline = _displayValue(result.headline, _defaultHeadline);
      _description = _displayValue(result.description, _defaultDescription);
      _avatarIndex = result.avatarIndex
          .clamp(0, _avatarOptions.length - 1)
          .toInt();
    });

    await _persistCoachCustomization();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Витрина тренера обновлена')),
      );
    }
  }

  Future<void> _openSpecializationEditor(BuildContext context) async {
    final result = await showModalBottomSheet<_CoachSpecializationEditorResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CoachSpecializationEditorSheet(
        initialSpecialization: _specialization,
        initialSportsAccents:
            _sportsAccents == _defaultSportsAccents ? '' : _sportsAccents,
        initialAchievements:
            _achievements == _defaultAchievements ? '' : _achievements,
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _specialization = _displayValue(
        result.specialization,
        _specializationFallback(widget.account.favoriteSport),
      );
      _sportsAccents = _displayValue(
        result.sportsAccents,
        _defaultSportsAccents,
      );
      _achievements = _displayValue(
        result.achievements,
        _defaultAchievements,
      );
    });

    await _persistCoachCustomization();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Специализация обновлена')),
      );
    }
  }

  Future<void> _openWorkFormatEditor(BuildContext context) async {
    final result = await showModalBottomSheet<_CoachWorkFormatEditorResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CoachWorkFormatEditorSheet(
        initialWorkFormat:
            _workFormat == _defaultWorkFormat ? '' : _workFormat,
        initialWorkMode: _workMode == _defaultWorkMode ? '' : _workMode,
        initialAvailability:
            _availability == _defaultAvailability ? '' : _availability,
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _workFormat = _displayValue(result.workFormat, _defaultWorkFormat);
      _workMode = _displayValue(result.workMode, _defaultWorkMode);
      _availability = _displayValue(
        result.availability,
        _defaultAvailability,
      );
    });

    await _persistCoachCustomization();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Формат работы обновлён')),
      );
    }
  }

  Future<void> _persistCoachCustomization() async {
    await ProfileCustomizationStorage.saveCoachCustomization(
      accountId: widget.account.id,
      customization: CoachProfileCustomization(
        displayName: _displayName.trim(),
        headline: _headline.trim(),
        description: _description.trim(),
        avatarIndex: _avatarIndex,
        specialization: _specialization.trim(),
        sportsAccents: _sportsAccents.trim(),
        achievements: _achievements.trim(),
        workFormat: _workFormat.trim(),
        workMode: _workMode.trim(),
        availability: _availability.trim(),
      ),
    );
  }

  Widget _buildHeaderAvatar() {
    final option = _avatarOptions[_avatarIndex];

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: option.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(option.icon, size: 30, color: option.iconColor),
    );
  }

  static String _fallbackName(String? rawName) {
    return _displayValue(rawName, 'Новый тренер SportGuider');
  }

  static String _specializationFallback(String? rawValue) {
    return _displayValue(rawValue, 'Функциональная подготовка');
  }

  static List<String> _buildSpecializationTags({
    required String specialization,
    required String sportsAccents,
    required String achievements,
  }) {
    final tags = <String>[
      specialization,
      ..._extractTagParts(sportsAccents),
      ..._extractTagParts(achievements),
    ];

    final uniqueTags = <String>[];
    for (final tag in tags) {
      if (tag.isEmpty || uniqueTags.contains(tag)) {
        continue;
      }

      uniqueTags.add(tag);
      if (uniqueTags.length == 4) {
        break;
      }
    }

    return uniqueTags;
  }

  static List<String> _extractTagParts(String value) {
    return value
        .split(RegExp(r'[,/;\n]+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty && part.length <= 28)
        .toList();
  }

  static String _displayValue(String? value, String fallback) {
    if (value == null) {
      return fallback;
    }

    final normalized = value.trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
      return fallback;
    }

    return normalized;
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

class _CoachAvatarOption {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _CoachAvatarOption(this.icon, this.backgroundColor, this.iconColor);
}

class _CoachShowcaseEditorResult {
  final String displayName;
  final String headline;
  final String description;
  final int avatarIndex;

  const _CoachShowcaseEditorResult({
    required this.displayName,
    required this.headline,
    required this.description,
    required this.avatarIndex,
  });
}

class _CoachSpecializationEditorResult {
  final String specialization;
  final String sportsAccents;
  final String achievements;

  const _CoachSpecializationEditorResult({
    required this.specialization,
    required this.sportsAccents,
    required this.achievements,
  });
}

class _CoachWorkFormatEditorResult {
  final String workFormat;
  final String workMode;
  final String availability;

  const _CoachWorkFormatEditorResult({
    required this.workFormat,
    required this.workMode,
    required this.availability,
  });
}

class _CoachShowcaseEditorSheet extends StatefulWidget {
  final List<_CoachAvatarOption> avatarOptions;
  final int initialAvatarIndex;
  final String initialDisplayName;
  final String initialHeadline;
  final String initialDescription;

  const _CoachShowcaseEditorSheet({
    required this.avatarOptions,
    required this.initialAvatarIndex,
    required this.initialDisplayName,
    required this.initialHeadline,
    required this.initialDescription,
  });

  @override
  State<_CoachShowcaseEditorSheet> createState() =>
      _CoachShowcaseEditorSheetState();
}

class _CoachShowcaseEditorSheetState extends State<_CoachShowcaseEditorSheet> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _descriptionController;
  late int _selectedAvatarIndex;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.initialDisplayName,
    );
    _headlineController = TextEditingController(text: widget.initialHeadline);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _selectedAvatarIndex = widget.initialAvatarIndex;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _headlineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CoachEditorSheet(
      title: 'Витрина тренера',
      subtitle:
          'Обновите ключевые элементы первого экрана: имя, аватар, короткий слоган и описание профиля.',
      saveLabel: 'Сохранить витрину',
      onSave: () {
        Navigator.of(context).pop(
          _CoachShowcaseEditorResult(
            displayName: _displayNameController.text,
            headline: _headlineController.text,
            description: _descriptionController.text,
            avatarIndex: _selectedAvatarIndex,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CoachEditorLabel(title: 'Аватар'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(widget.avatarOptions.length, (index) {
              final option = widget.avatarOptions[index];
              final isSelected = index == _selectedAvatarIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatarIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: option.backgroundColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.activeColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    option.icon,
                    size: 32,
                    color: option.iconColor,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const _CoachEditorLabel(title: 'Отображаемое имя'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _displayNameController,
            hintText: 'Например, Илья Смирнов / Coach Anna',
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Короткий слоган'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _headlineController,
            hintText: 'Например, тренировки с понятным прогрессом',
            minLines: 2,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Первое впечатление'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _descriptionController,
            hintText:
                'Коротко опишите подход, стиль работы и ощущение от занятий с вами.',
            minLines: 3,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _CoachSpecializationEditorSheet extends StatefulWidget {
  final String initialSpecialization;
  final String initialSportsAccents;
  final String initialAchievements;

  const _CoachSpecializationEditorSheet({
    required this.initialSpecialization,
    required this.initialSportsAccents,
    required this.initialAchievements,
  });

  @override
  State<_CoachSpecializationEditorSheet> createState() =>
      _CoachSpecializationEditorSheetState();
}

class _CoachSpecializationEditorSheetState
    extends State<_CoachSpecializationEditorSheet> {
  late final TextEditingController _specializationController;
  late final TextEditingController _sportsAccentsController;
  late final TextEditingController _achievementsController;

  @override
  void initState() {
    super.initState();
    _specializationController = TextEditingController(
      text: widget.initialSpecialization,
    );
    _sportsAccentsController = TextEditingController(
      text: widget.initialSportsAccents,
    );
    _achievementsController = TextEditingController(
      text: widget.initialAchievements,
    );
  }

  @override
  void dispose() {
    _specializationController.dispose();
    _sportsAccentsController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CoachEditorSheet(
      title: 'Специализация',
      subtitle:
          'Заполните направление подготовки, спортивные акценты и достижения, чтобы профиль тренера выглядел убедительнее.',
      saveLabel: 'Сохранить специализацию',
      onSave: () {
        Navigator.of(context).pop(
          _CoachSpecializationEditorResult(
            specialization: _specializationController.text,
            sportsAccents: _sportsAccentsController.text,
            achievements: _achievementsController.text,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CoachEditorLabel(title: 'Основное направление'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _specializationController,
            hintText: 'Например, функциональная подготовка / бег / ОФП',
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Спортивные акценты'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _sportsAccentsController,
            hintText: 'Какие сильные стороны и акценты вы хотите показать?',
            minLines: 3,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Достижения'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _achievementsController,
            hintText: 'Кратко опишите опыт, результаты или достижения.',
            minLines: 3,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _CoachWorkFormatEditorSheet extends StatefulWidget {
  final String initialWorkFormat;
  final String initialWorkMode;
  final String initialAvailability;

  const _CoachWorkFormatEditorSheet({
    required this.initialWorkFormat,
    required this.initialWorkMode,
    required this.initialAvailability,
  });

  @override
  State<_CoachWorkFormatEditorSheet> createState() =>
      _CoachWorkFormatEditorSheetState();
}

class _CoachWorkFormatEditorSheetState
    extends State<_CoachWorkFormatEditorSheet> {
  late final TextEditingController _workFormatController;
  late final TextEditingController _workModeController;
  late final TextEditingController _availabilityController;

  @override
  void initState() {
    super.initState();
    _workFormatController = TextEditingController(
      text: widget.initialWorkFormat,
    );
    _workModeController = TextEditingController(text: widget.initialWorkMode);
    _availabilityController = TextEditingController(
      text: widget.initialAvailability,
    );
  }

  @override
  void dispose() {
    _workFormatController.dispose();
    _workModeController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CoachEditorSheet(
      title: 'Формат работы',
      subtitle:
          'Укажите, как проходят занятия, доступны ли онлайн-сессии и насколько легко записаться к вам.',
      saveLabel: 'Сохранить формат',
      onSave: () {
        Navigator.of(context).pop(
          _CoachWorkFormatEditorResult(
            workFormat: _workFormatController.text,
            workMode: _workModeController.text,
            availability: _availabilityController.text,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CoachEditorLabel(title: 'Формат занятий'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _workFormatController,
            hintText: 'Например, индивидуально, мини-группы',
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Онлайн / офлайн'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _workModeController,
            hintText: 'Например, онлайн и офлайн / только офлайн',
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Доступность для записи'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _availabilityController,
            hintText: 'Например, открыт к новым заявкам по средам и пятницам',
            minLines: 2,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _CoachEditorSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String saveLabel;
  final VoidCallback onSave;
  final Widget child;

  const _CoachEditorSheet({
    required this.title,
    required this.subtitle,
    required this.saveLabel,
    required this.onSave,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return FractionallySizedBox(
      heightFactor: 0.86,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 24 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: GoogleFonts.philosopher(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                child,
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      onSave();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.activeColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      saveLabel,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoachEditorLabel extends StatelessWidget {
  final String title;

  const _CoachEditorLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.philosopher(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryColor,
      ),
    );
  }
}

class _CoachEditorField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const _CoachEditorField({
    required this.controller,
    required this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedKeyboardType = keyboardType ?? TextInputType.multiline;
    final resolvedTextCapitalization =
        resolvedKeyboardType == TextInputType.emailAddress ||
            resolvedKeyboardType == TextInputType.phone
        ? TextCapitalization.none
        : textCapitalization;

    return TextField(
      controller: controller,
      keyboardType: resolvedKeyboardType,
      textCapitalization: resolvedTextCapitalization,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.textPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textSecondaryColor),
        filled: true,
        fillColor: AppColors.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.activeColor, width: 1.5),
        ),
      ),
    );
  }
}
