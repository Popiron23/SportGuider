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
class UserProfilePage extends StatefulWidget {
  final AccountEntity account;

  const UserProfilePage({super.key, required this.account});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  static const _defaultDescription =
      'Добавьте пару слов о себе, целях и любимом формате тренировок.';

  static const List<_AvatarOption> _avatarOptions = [
    _AvatarOption(
      icon: Icons.person_outline_rounded,
      backgroundColor: Color(0x1FFFFFFF),
      iconColor: Colors.white,
    ),
    _AvatarOption(
      icon: Icons.directions_run_rounded,
      backgroundColor: Color(0xFFE9F7F1),
      iconColor: Color(0xFF20A77B),
    ),
    _AvatarOption(
      icon: Icons.sports_basketball_rounded,
      backgroundColor: Color(0xFFFFF0E4),
      iconColor: Color(0xFFFF9F45),
    ),
    _AvatarOption(
      icon: Icons.sports_soccer_rounded,
      backgroundColor: Color(0xFFEAF3FF),
      iconColor: Color(0xFF4B67F0),
    ),
    _AvatarOption(
      icon: Icons.pool_rounded,
      backgroundColor: Color(0xFFE7F8FF),
      iconColor: Color(0xFF21A7C9),
    ),
    _AvatarOption(
      icon: Icons.fitness_center_rounded,
      backgroundColor: Color(0xFFFFEEEC),
      iconColor: Color(0xFFFF6E63),
    ),
  ];

  late String _displayName;
  late String _shortDescription;
  int _avatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayName = _fallbackName(widget.account.name);
    _shortDescription = _defaultDescription;
    _loadCustomization();
  }

  Future<void> _loadCustomization() async {
    final customization = await ProfileCustomizationStorage
        .readUserCustomization(widget.account.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _displayName = customization.displayName.trim().isNotEmpty
          ? customization.displayName.trim()
          : _fallbackName(widget.account.name);
      _shortDescription = customization.shortDescription.trim().isNotEmpty
          ? customization.shortDescription.trim()
          : _defaultDescription;
      _avatarIndex = customization.avatarIndex
          .clamp(0, _avatarOptions.length - 1)
          .toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final coaches = widget.account.coaches
        .where((coach) => coach.trim().isNotEmpty)
        .toList();
    final favoriteSport = _normalizedValue(
      widget.account.favoriteSport,
      'В поиске любимого спорта',
    );

    return ProfileShell(
      account: widget.account.copyWith(name: _displayName),
      roleLabel: 'ПРОФИЛЬ СПОРТСМЕНА',
      headline: 'Личный кабинет для тренировок, маршрутов и общения с тренерами.',
      description: _shortDescription,
      editTitle: 'Редактирование профиля спортсмена',
      editButtonLabel: 'Редактировать профиль',
      activityBadge: 'В форме',
      accentColor: AppColors.activeColor,
      secondaryAccentColor: AppColors.activeDarkColor,
      avatar: _buildHeaderAvatar(),
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
      editOptions: [
        ProfileEditOption(
          icon: Icons.person_outline_rounded,
          title: 'Фото и имя',
          subtitle:
              'Обновить аватар, отображаемое имя и короткое описание.',
          onTap: _openIdentityEditor,
        ),
        const ProfileEditOption(
          icon: Icons.contact_mail_outlined,
          title: 'Контакты',
          subtitle: 'Почта, телефон и предпочтительный способ связи.',
        ),
        const ProfileEditOption(
          icon: Icons.fitness_center_rounded,
          title: 'Спортивные данные',
          subtitle: 'Любимый спорт, цели тренировок и текущий фокус.',
        ),
      ],
      sections: [
        ProfileSectionCard(
          title: 'Контакты',
          subtitle:
              'Базовая информация, чтобы быстро связаться или узнать чей это профиль.',
          child: Column(
            children: [
              ProfileInfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'E-mail',
                value: _normalizedValue(
                  widget.account.email,
                  'Добавьте почту для связи',
                ),
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.phone_outlined,
                label: 'Телефон',
                value: _normalizedValue(
                  widget.account.phoneNumber,
                  'Телефон пока не указан',
                ),
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.badge_outlined,
                label: 'ID профиля',
                value: widget.account.id,
              ),
            ],
          ),
        ),
        ProfileSectionCard(
          title: 'Спортивный фокус',
          subtitle:
              'Блок можно использовать как быстрый срез по текущему настрою и интересам пользователя.',
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
                value:
                    'Найти подходящего тренера и выстроить удобный ритм занятий.',
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
          subtitle:
              'Здесь органично смотрится список специалистов, которых пользователь уже добавил или с кем занимается.',
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

  Future<void> _openIdentityEditor(BuildContext context) async {
    final result = await showModalBottomSheet<_IdentityEditorResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _IdentityEditorSheet(
        avatarOptions: _avatarOptions,
        initialAvatarIndex: _avatarIndex,
        initialDisplayName: _displayName,
        initialShortDescription: _shortDescription == _defaultDescription
            ? ''
            : _shortDescription,
      ),
    );

    if (result == null) {
      return;
    }

    final normalizedName = result.displayName.trim();
    final normalizedDescription = result.shortDescription.trim();

    await ProfileCustomizationStorage.saveUserCustomization(
      accountId: widget.account.id,
      displayName: normalizedName,
      shortDescription: normalizedDescription,
      avatarIndex: result.avatarIndex,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _displayName = normalizedName.isNotEmpty
          ? normalizedName
          : _fallbackName(widget.account.name);
      _shortDescription = normalizedDescription.isNotEmpty
          ? normalizedDescription
          : _defaultDescription;
      _avatarIndex = result.avatarIndex;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль спортсмена обновлён')),
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
    return _normalizedValue(rawName, 'Новый участник SportGuider');
  }

  static String _normalizedValue(String? value, String fallback) {
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

class _IdentityEditorSheet extends StatefulWidget {
  final List<_AvatarOption> avatarOptions;
  final int initialAvatarIndex;
  final String initialDisplayName;
  final String initialShortDescription;

  const _IdentityEditorSheet({
    required this.avatarOptions,
    required this.initialAvatarIndex,
    required this.initialDisplayName,
    required this.initialShortDescription,
  });

  @override
  State<_IdentityEditorSheet> createState() => _IdentityEditorSheetState();
}

class _IdentityEditorSheetState extends State<_IdentityEditorSheet> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _shortDescriptionController;
  late int _selectedAvatarIndex;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.initialDisplayName,
    );
    _shortDescriptionController = TextEditingController(
      text: widget.initialShortDescription,
    );
    _selectedAvatarIndex = widget.initialAvatarIndex;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _shortDescriptionController.dispose();
    super.dispose();
  }

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
                  'Фото и имя',
                  style: GoogleFonts.philosopher(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Выберите аватар, обновите отображаемое имя и добавьте короткое описание, которое будет видно в шапке профиля.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Аватар',
                  style: GoogleFonts.philosopher(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
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
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.activeColor.withValues(
                                      alpha: 0.14,
                                    ),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ]
                              : null,
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
                _EditorLabel(title: 'Отображаемое имя'),
                const SizedBox(height: 10),
                _EditorField(
                  controller: _displayNameController,
                  hintText: 'Например, Егор / Катя / Alex Runner',
                ),
                const SizedBox(height: 20),
                _EditorLabel(title: 'Короткое описание'),
                const SizedBox(height: 10),
                _EditorField(
                  controller: _shortDescriptionController,
                  hintText:
                      'Пара слов о себе, целях или любимом формате тренировок.',
                  minLines: 3,
                  maxLines: 4,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        _IdentityEditorResult(
                          displayName: _displayNameController.text,
                          shortDescription: _shortDescriptionController.text,
                          avatarIndex: _selectedAvatarIndex,
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.activeColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Сохранить изменения',
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

class _EditorLabel extends StatelessWidget {
  final String title;

  const _EditorLabel({required this.title});

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

class _EditorField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;

  const _EditorField({
    required this.controller,
    required this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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

class _AvatarOption {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _AvatarOption({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

class _IdentityEditorResult {
  final String displayName;
  final String shortDescription;
  final int avatarIndex;

  const _IdentityEditorResult({
    required this.displayName,
    required this.shortDescription,
    required this.avatarIndex,
  });
}
