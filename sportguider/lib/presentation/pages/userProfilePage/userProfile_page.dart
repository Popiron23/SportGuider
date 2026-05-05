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

part 'userProfile_models.dart';
part 'userProfile_components.dart';
part 'userProfile_editors.dart';

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
  bool _isLoading = true;
  List<_CoachCardData> _coachesData = [];

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
    final results = await Future.wait([
      ProfileCustomizationStorage.readUserCustomization(widget.account.id),
      ProfileCustomizationStorage.readUserCoaches(widget.account.id),
    ]);

    if (!mounted) return;

    final customization = results[0] as UserProfileCustomization;
    final coachIds = results[1] as List<String>;

    final coachDataList = await Future.wait(
      coachIds.map((id) async {
        final c = await ProfileCustomizationStorage.readCoachCustomization(id);
        return _CoachCardData(
          id: id,
          displayName: (c.displayName?.trim().isNotEmpty == true)
              ? c.displayName!
              : 'Тренер SportGuider',
          specialization: (c.specialization?.trim().isNotEmpty == true)
              ? c.specialization!
              : 'Тренер',
        );
      }),
    );

    if (!mounted) return;

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
      _coachesData = coachDataList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.activeColor),
        ),
      );
    }
    final favoriteSportText = _displayValue(
      _favoriteSport,
      'В поиске любимого спорта',
    );
    final currentFocusText = _displayValue(_currentFocus, _defaultCurrentFocus);

    final isOwner =
        widget.account.id == FirebaseService.auth.currentUser?.uid;

    return ProfileShell(
      isOwner: isOwner,
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
          child: _coachesData.isEmpty
              ? const ProfileEmptyState(
                  title: 'Пока пусто',
                  subtitle:
                      'Когда пользователь выберет тренера, его карточка или имя могут появляться прямо в этом блоке.',
                )
              : Column(
                  children: _coachesData
                      .map(
                        (coach) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: GestureDetector(
                            onTap: () => context.router.push(
                              CoachProfileRoute(
                                account: AccountEntity(id: coach.id),
                              ),
                            ),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          coach.displayName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          coach.specialization,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.textSecondaryColor,
                                  ),
                                ],
                              ),
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
