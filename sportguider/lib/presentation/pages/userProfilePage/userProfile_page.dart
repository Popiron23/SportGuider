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
  static const _defaultTrainingGoal =
      'Найти подходящего тренера и выстроить удобный ритм занятий.';
  static const _defaultCurrentFocus = 'Новые тренировки';
  static const _defaultPreferredContactMethod = 'Чат в приложении';
  static const _contactMethodOptions = [
    'Чат в приложении',
    'Телефон',
    'Почта',
    'Telegram',
  ];

  static const List<_AvatarOption> _avatarOptions = [
    _AvatarOption(
      Icons.person_outline_rounded,
      Color(0xFFEAF3FF),
      Color(0xFF4B67F0),
    ),
    _AvatarOption(
      Icons.directions_run_rounded,
      Color(0xFFE9F7F1),
      Color(0xFF20A77B),
    ),
    _AvatarOption(
      Icons.sports_basketball_rounded,
      Color(0xFFFFF0E4),
      Color(0xFFFF9F45),
    ),
    _AvatarOption(
      Icons.sports_soccer_rounded,
      Color(0xFFEAF3FF),
      Color(0xFF2D7DFF),
    ),
    _AvatarOption(Icons.pool_rounded, Color(0xFFE7F8FF), Color(0xFF21A7C9)),
    _AvatarOption(
      Icons.fitness_center_rounded,
      Color(0xFFFFEEEC),
      Color(0xFFFF6E63),
    ),
  ];

  late String _displayName;
  late String _shortDescription;
  late String _contactEmail;
  late String _contactPhone;
  late String _preferredContactMethod;
  late String _favoriteSport;
  late String _trainingGoal;
  late String _currentFocus;
  int _avatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayName = _fallbackName(widget.account.name);
    _shortDescription = _defaultDescription;
    _contactEmail = _editableValue(widget.account.email);
    _contactPhone = _editableValue(widget.account.phoneNumber);
    _preferredContactMethod = _defaultPreferredContactMethod;
    _favoriteSport = _editableValue(widget.account.favoriteSport);
    _trainingGoal = _defaultTrainingGoal;
    _currentFocus = _defaultCurrentFocus;
    _loadCustomization();
  }

  Future<void> _loadCustomization() async {
    final customization =
        await ProfileCustomizationStorage.readUserCustomization(
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
      if (customization.shortDescription != null) {
        _shortDescription = _displayValue(
          customization.shortDescription!,
          _defaultDescription,
        );
      }
      if (customization.avatarIndex != null) {
        _avatarIndex = customization.avatarIndex!
            .clamp(0, _avatarOptions.length - 1)
            .toInt();
      }
      if (customization.contactEmail != null) {
        _contactEmail = customization.contactEmail!;
      }
      if (customization.contactPhone != null) {
        _contactPhone = customization.contactPhone!;
      }
      if (customization.preferredContactMethod != null) {
        _preferredContactMethod = _displayValue(
          customization.preferredContactMethod!,
          _defaultPreferredContactMethod,
        );
      }
      if (customization.favoriteSport != null) {
        _favoriteSport = customization.favoriteSport!;
      }
      if (customization.trainingGoal != null) {
        _trainingGoal = _displayValue(
          customization.trainingGoal!,
          _defaultTrainingGoal,
        );
      }
      if (customization.currentFocus != null) {
        _currentFocus = _displayValue(
          customization.currentFocus!,
          _defaultCurrentFocus,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final coaches = widget.account.coaches
        .where((coach) => coach.trim().isNotEmpty)
        .toList();
    final favoriteSportText = _displayValue(
      _favoriteSport,
      'В поиске любимого спорта',
    );
    final currentFocusText = _displayValue(_currentFocus, _defaultCurrentFocus);

    return ProfileShell(
      account: widget.account.copyWith(
        name: _displayName,
        favoriteSport: favoriteSportText,
      ),
      roleLabel: 'ПРОФИЛЬ СПОРТСМЕНА',
      headline:
          'Личный кабинет для тренировок, маршрутов и общения с тренерами.',
      description: _displayValue(_shortDescription, _defaultDescription),
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
          value: favoriteSportText,
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
          label: 'Фокус',
          value: currentFocusText,
          accentColor: AppColors.warningColor,
        ),
      ],
      editOptions: [
        ProfileEditOption(
          icon: Icons.person_outline_rounded,
          title: 'Фото и имя',
          subtitle: 'Обновить аватар, отображаемое имя и короткое описание.',
          onTap: _openIdentityEditor,
        ),
        ProfileEditOption(
          icon: Icons.contact_mail_outlined,
          title: 'Контакты',
          subtitle: 'Почта, телефон и предпочтительный способ связи.',
          onTap: _openContactsEditor,
        ),
        ProfileEditOption(
          icon: Icons.fitness_center_rounded,
          title: 'Спортивные данные',
          subtitle: 'Любимый спорт, цели тренировок и текущий фокус.',
          onTap: _openSportsEditor,
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
                value: _displayValue(_contactEmail, 'Добавьте почту для связи'),
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.phone_outlined,
                label: 'Телефон',
                value: _displayValue(_contactPhone, 'Телефон пока не указан'),
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Предпочтительный способ связи',
                value: _displayValue(
                  _preferredContactMethod,
                  _defaultPreferredContactMethod,
                ),
              ),
              const SizedBox(height: 18),
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
                value: favoriteSportText,
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.flag_outlined,
                label: 'Текущая цель',
                value: _displayValue(_trainingGoal, _defaultTrainingGoal),
              ),
              const SizedBox(height: 18),
              ProfileInfoRow(
                icon: Icons.bolt_rounded,
                label: 'Текущий фокус',
                value: currentFocusText,
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ProfileTag(
                    text: favoriteSportText,
                    color: AppColors.activeColor,
                  ),
                  ProfileTag(
                    text: currentFocusText,
                    color: AppColors.successColor,
                  ),
                  ProfileTag(text: 'Прогресс', color: AppColors.warningColor),
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

    setState(() {
      _displayName = _displayValue(
        result.displayName,
        _fallbackName(widget.account.name),
      );
      _shortDescription = _displayValue(
        result.shortDescription,
        _defaultDescription,
      );
      _avatarIndex = result.avatarIndex
          .clamp(0, _avatarOptions.length - 1)
          .toInt();
    });

    await _persistCustomization();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Фото, имя и описание обновлены')),
      );
    }
  }

  Future<void> _openContactsEditor(BuildContext context) async {
    final result = await showModalBottomSheet<_ContactsEditorResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ContactsEditorSheet(
        initialEmail: _contactEmail,
        initialPhone: _contactPhone,
        initialPreferredContactMethod: _preferredContactMethod,
        contactMethodOptions: _contactMethodOptions,
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _contactEmail = result.email.trim();
      _contactPhone = result.phone.trim();
      _preferredContactMethod = _displayValue(
        result.preferredContactMethod,
        _defaultPreferredContactMethod,
      );
    });

    await _persistCustomization();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Контакты обновлены')));
    }
  }

  Future<void> _openSportsEditor(BuildContext context) async {
    final result = await showModalBottomSheet<_SportsEditorResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SportsEditorSheet(
        initialFavoriteSport: _favoriteSport,
        initialTrainingGoal: _trainingGoal,
        initialCurrentFocus: _currentFocus,
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _favoriteSport = result.favoriteSport.trim();
      _trainingGoal = _displayValue(result.trainingGoal, _defaultTrainingGoal);
      _currentFocus = _displayValue(result.currentFocus, _defaultCurrentFocus);
    });

    await _persistCustomization();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Спортивные данные обновлены')),
      );
    }
  }

  Future<void> _persistCustomization() async {
    await ProfileCustomizationStorage.saveUserCustomization(
      accountId: widget.account.id,
      customization: UserProfileCustomization(
        displayName: _displayName.trim(),
        shortDescription: _shortDescription.trim(),
        avatarIndex: _avatarIndex,
        contactEmail: _contactEmail.trim(),
        contactPhone: _contactPhone.trim(),
        preferredContactMethod: _preferredContactMethod.trim(),
        favoriteSport: _favoriteSport.trim(),
        trainingGoal: _trainingGoal.trim(),
        currentFocus: _currentFocus.trim(),
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

  static String _editableValue(String? value) {
    if (value == null) {
      return '';
    }

    final normalized = value.trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
      return '';
    }

    return normalized;
  }

  static String _fallbackName(String? rawName) {
    return _displayValue(rawName, 'Новый участник SportGuider');
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

class _AvatarOption {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _AvatarOption(this.icon, this.backgroundColor, this.iconColor);
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

class _ContactsEditorResult {
  final String email;
  final String phone;
  final String preferredContactMethod;

  const _ContactsEditorResult({
    required this.email,
    required this.phone,
    required this.preferredContactMethod,
  });
}

class _SportsEditorResult {
  final String favoriteSport;
  final String trainingGoal;
  final String currentFocus;

  const _SportsEditorResult({
    required this.favoriteSport,
    required this.trainingGoal,
    required this.currentFocus,
  });
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
    return _StableEditorSheet(
      title: 'Фото и имя',
      subtitle:
          'Выберите аватар, обновите отображаемое имя и добавьте короткое описание, которое будет видно в шапке профиля.',
      saveLabel: 'Сохранить изменения',
      onSave: () {
        Navigator.of(context).pop(
          _IdentityEditorResult(
            displayName: _displayNameController.text,
            shortDescription: _shortDescriptionController.text,
            avatarIndex: _selectedAvatarIndex,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StableEditorLabel(title: 'Аватар'),
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
                  child: Icon(option.icon, size: 32, color: option.iconColor),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const _StableEditorLabel(title: 'Отображаемое имя'),
          const SizedBox(height: 10),
          _StableEditorField(
            controller: _displayNameController,
            hintText: 'Например, Егор / Alex Runner',
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          const _StableEditorLabel(title: 'Короткое описание'),
          const SizedBox(height: 10),
          _StableEditorField(
            controller: _shortDescriptionController,
            hintText: 'Пара слов о себе, целях или любимом формате тренировок.',
            minLines: 3,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _ContactsEditorSheet extends StatefulWidget {
  final String initialEmail;
  final String initialPhone;
  final String initialPreferredContactMethod;
  final List<String> contactMethodOptions;

  const _ContactsEditorSheet({
    required this.initialEmail,
    required this.initialPhone,
    required this.initialPreferredContactMethod,
    required this.contactMethodOptions,
  });

  @override
  State<_ContactsEditorSheet> createState() => _ContactsEditorSheetState();
}

class _ContactsEditorSheetState extends State<_ContactsEditorSheet> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late String _selectedContactMethod;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _selectedContactMethod = widget.initialPreferredContactMethod;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StableEditorSheet(
      title: 'Контакты',
      subtitle:
          'Обновите данные для связи, чтобы тренеру или команде было проще быстро с вами связаться.',
      saveLabel: 'Сохранить контакты',
      onSave: () {
        Navigator.of(context).pop(
          _ContactsEditorResult(
            email: _emailController.text,
            phone: _phoneController.text,
            preferredContactMethod: _selectedContactMethod,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StableEditorLabel(title: 'E-mail'),
          const SizedBox(height: 10),
          _StableEditorField(
            controller: _emailController,
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          const _StableEditorLabel(title: 'Телефон'),
          const SizedBox(height: 10),
          _StableEditorField(
            controller: _phoneController,
            hintText: '+7 999 123-45-67',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          const _StableEditorLabel(title: 'Предпочтительный способ связи'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.contactMethodOptions
                .map(
                  (option) => ChoiceChip(
                    label: Text(option),
                    selected: _selectedContactMethod == option,
                    selectedColor: AppColors.activeColor.withValues(
                      alpha: 0.16,
                    ),
                    backgroundColor: AppColors.backgroundColor,
                    side: BorderSide(
                      color: _selectedContactMethod == option
                          ? AppColors.activeColor
                          : AppColors.borderColor,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedContactMethod == option
                          ? AppColors.activeColor
                          : AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedContactMethod = option;
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SportsEditorSheet extends StatefulWidget {
  final String initialFavoriteSport;
  final String initialTrainingGoal;
  final String initialCurrentFocus;

  const _SportsEditorSheet({
    required this.initialFavoriteSport,
    required this.initialTrainingGoal,
    required this.initialCurrentFocus,
  });

  @override
  State<_SportsEditorSheet> createState() => _SportsEditorSheetState();
}

class _SportsEditorSheetState extends State<_SportsEditorSheet> {
  late final TextEditingController _favoriteSportController;
  late final TextEditingController _trainingGoalController;
  late final TextEditingController _currentFocusController;

  @override
  void initState() {
    super.initState();
    _favoriteSportController = TextEditingController(
      text: widget.initialFavoriteSport,
    );
    _trainingGoalController = TextEditingController(
      text: widget.initialTrainingGoal,
    );
    _currentFocusController = TextEditingController(
      text: widget.initialCurrentFocus,
    );
  }

  @override
  void dispose() {
    _favoriteSportController.dispose();
    _trainingGoalController.dispose();
    _currentFocusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StableEditorSheet(
      title: 'Спортивные данные',
      subtitle:
          'Заполните спортивный фокус, чтобы профиль выглядел живее и сразу показывал ваш настрой.',
      saveLabel: 'Сохранить спортивные данные',
      onSave: () {
        Navigator.of(context).pop(
          _SportsEditorResult(
            favoriteSport: _favoriteSportController.text,
            trainingGoal: _trainingGoalController.text,
            currentFocus: _currentFocusController.text,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StableEditorLabel(title: 'Любимый спорт'),
          const SizedBox(height: 10),
          _StableEditorField(
            controller: _favoriteSportController,
            hintText: 'Например, баскетбол / плавание / бег',
          ),
          const SizedBox(height: 20),
          const _StableEditorLabel(title: 'Цель тренировок'),
          const SizedBox(height: 10),
          _StableEditorField(
            controller: _trainingGoalController,
            hintText: 'Какую цель вы хотите достичь в ближайшее время?',
            minLines: 3,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          const _StableEditorLabel(title: 'Текущий фокус'),
          const SizedBox(height: 10),
          _StableEditorField(
            controller: _currentFocusController,
            hintText: 'Например, выносливость / техника / новые маршруты',
          ),
        ],
      ),
    );
  }
}

class _StableEditorSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String saveLabel;
  final VoidCallback onSave;
  final Widget child;

  const _StableEditorSheet({
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

class _StableEditorLabel extends StatelessWidget {
  final String title;

  const _StableEditorLabel({required this.title});

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

class _StableEditorField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const _StableEditorField({
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
