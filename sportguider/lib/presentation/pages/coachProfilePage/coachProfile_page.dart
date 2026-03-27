import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/data/models/coach_organization_model.dart';
import 'package:sportguider/data/repositories/coach_organizations_repository.dart';
import 'package:sportguider/database_service.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/profile/profile_customization_storage.dart';
import 'package:sportguider/presentation/pages/profile/profile_role_storage.dart';
import 'package:sportguider/presentation/pages/profile/widgets/profile_shell.dart';
import 'package:sportguider/routes/router.gr.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

part 'coachProfile_models.dart';
part 'coachProfile_components.dart';
part 'coachProfile_editors.dart';
part 'coachProfile_organization.dart';

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
  static const _defaultOrganizationSport = 'Функциональная подготовка';
  static const _defaultOrganizationAddress = 'Адрес организации появится здесь';
  static const _defaultOrganizationDescription =
      'Точка на карте, к которой прикреплён тренер, будет отображаться в этом блоке.';

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
  late String _contactPhone;
  List<_CoachOrganization> _organizations = [];
  _CoachOrganization? _selectedOrganization;
  int _avatarIndex = 0;
  bool _isLoadingOrganizations = true;
  bool _isLoading = true;
  bool _isCoachAdded = false;
  bool _isAddingCoach = false;
  List<String> _currentUserCoaches = [];
  bool _currentUserIsCoach = false;
  bool _coachStatusLoaded = false;
  List<_AthleteCardData> _athletesData = [];

  final _organizationsRepo = CoachOrganizationsRepository();

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
    _contactPhone = widget.account.phoneNumber?.trim() ?? '';
    _loadCustomization();
    final currentUid = FirebaseService.auth.currentUser?.uid;
    if (currentUid != null && currentUid != widget.account.id) {
      _loadCoachStatus(currentUid);
    }
  }

  Future<void> _loadCoachStatus(String currentUserId) async {
    final results = await Future.wait([
      ProfileCustomizationStorage.readUserCoaches(currentUserId),
      ProfileRoleStorage.readRole(),
    ]);
    if (!mounted) return;
    final coaches = results[0] as List<String>;
    final role = results[1] as Role;
    setState(() {
      _currentUserCoaches = coaches;
      _isCoachAdded = coaches.contains(widget.account.id);
      _currentUserIsCoach = role == Role.coach;
      _coachStatusLoaded = true;
    });
  }

  Future<void> _toggleCoach() async {
    final userId = FirebaseService.auth.currentUser?.uid;
    if (userId == null) return;
    setState(() => _isAddingCoach = true);
    final updated = List<String>.from(_currentUserCoaches);
    if (_isCoachAdded) {
      updated.remove(widget.account.id);
      await Future.wait([
        ProfileCustomizationStorage.saveUserCoaches(userId, updated),
        DatabaseService().delete(
          path: 'CoachAthletes/${widget.account.id}/$userId',
        ),
      ]);
    } else {
      updated.add(widget.account.id);
      await Future.wait([
        ProfileCustomizationStorage.saveUserCoaches(userId, updated),
        DatabaseService().update(
          path: 'CoachAthletes/${widget.account.id}',
          data: {userId: true},
        ),
      ]);
    }
    if (!mounted) return;
    setState(() {
      _currentUserCoaches = updated;
      _isCoachAdded = !_isCoachAdded;
      _isAddingCoach = false;
    });
  }

  Future<void> _loadCustomization() async {
    final results = await Future.wait([
      ProfileCustomizationStorage.readCoachCustomization(widget.account.id),
      _organizationsRepo.getAll(),
      ProfileCustomizationStorage.readCoachAthletes(widget.account.id),
    ]);

    if (!mounted) return;

    final customization = results[0] as CoachProfileCustomization;
    var organizationModels = results[1] as List<CoachOrganizationModel>;
    final athleteIds = results[2] as List<String>;

    if (organizationModels.isEmpty) {
      organizationModels = await _organizationsRepo.seedPresets();
      if (!mounted) return;
    }

    setState(() {
      _organizations = organizationModels
          .map(_CoachOrganization.fromModel)
          .toList();
      _isLoadingOrganizations = false;

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
        _workMode = _displayValue(customization.workMode!, _defaultWorkMode);
      }
      if (customization.availability != null) {
        _availability = _displayValue(
          customization.availability!,
          _defaultAvailability,
        );
      }
      if (customization.contactPhone != null) {
        _contactPhone = customization.contactPhone!.trim();
      }

      // Resolve selected org: first by ID (new), then by name/address (legacy)
      final savedId = customization.organizationId;
      if (savedId != null && savedId.isNotEmpty) {
        _selectedOrganization = _organizations
            .where((o) => o.id == savedId)
            .firstOrNull;
      }
      if (_selectedOrganization == null) {
        final legacy = _organizationFromCustomization(customization);
        if (legacy != null) {
          _selectedOrganization = _findOrganization(legacy) ?? legacy;
        }
      }
      _isLoading = false;
    });

    if (athleteIds.isNotEmpty) {
      final athletes = await Future.wait(
        athleteIds.map((id) async {
          final c = await ProfileCustomizationStorage.readUserCustomization(id);
          return _AthleteCardData(
            id: id,
            displayName: (c.displayName?.trim().isNotEmpty == true)
                ? c.displayName!
                : 'Спортсмен SportGuider',
          );
        }),
      );
      if (!mounted) return;
      setState(() => _athletesData = athletes);
    }
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

    final isOwner =
        FirebaseService.auth.currentUser?.uid == widget.account.id;

    return ProfileShell(
      isOwner: isOwner,
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
          subtitle: 'Направления подготовки, спортивные акценты и достижения.',
          onTap: _openSpecializationEditor,
        ),
        ProfileEditOption(
          icon: Icons.schedule_outlined,
          title: 'Формат работы',
          subtitle:
              'Индивидуально, группы, онлайн, офлайн и доступность для записи.',
          onTap: _openWorkFormatEditor,
        ),
        ProfileEditOption(
          icon: Icons.location_city_outlined,
          title: 'Организация',
          subtitle:
              'Выберите место на карте, к которому вы прикреплены, или добавьте свою точку.',
          onTap: _openOrganizationEditor,
        ),
      ],
      sections: [
        if (!isOwner && _coachStatusLoaded && !_currentUserIsCoach)
          _AddCoachButton(
            isAdded: _isCoachAdded,
            isLoading: _isAddingCoach,
            onTap: _toggleCoach,
          ),
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
                icon: Icons.phone_outlined,
                label: 'Телефон',
                value: _contactPhone.isNotEmpty
                    ? _contactPhone
                    : 'Телефон не указан',
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
          title: 'Организация',
          subtitle:
              'Показывает, к какой точке на карте прикреплён тренер и где проходят его занятия.',
          child: _selectedOrganization == null
              ? _CoachOrganizationEmptyState(
                  onSelect: () => _openOrganizationEditor(context),
                  isOwner: isOwner,
                )
              : _CoachOrganizationDetails(
                  organization: _selectedOrganization!,
                  accentColor: const Color(0xFF1D9A9D),
                  currentAccountId: widget.account.id,
                ),
        ),
        if (isOwner)
          ProfileSectionCard(
            title: 'Мои спортсмены',
            subtitle: 'Спортсмены, которые добавили вас к себе в тренеры.',
            child: _athletesData.isEmpty
                ? const ProfileEmptyState(
                    title: 'Пока никого нет',
                    subtitle:
                        'Когда спортсмен добавит вас в тренеры, он появится здесь.',
                  )
                : Column(
                    children: _athletesData
                        .map(
                          (athlete) => Padding(
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
                                      color: const Color(0xFFE9F7F1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.directions_run_rounded,
                                      color: Color(0xFF20A77B),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      athlete.displayName,
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
        initialDescription: _description == _defaultDescription
            ? ''
            : _description,
        initialContactPhone: _contactPhone,
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
      _contactPhone = result.contactPhone.trim();
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
        initialSportsAccents: _sportsAccents == _defaultSportsAccents
            ? ''
            : _sportsAccents,
        initialAchievements: _achievements == _defaultAchievements
            ? ''
            : _achievements,
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
      _achievements = _displayValue(result.achievements, _defaultAchievements);
    });

    await _persistCoachCustomization();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Специализация обновлена')));
    }
  }

  Future<void> _openWorkFormatEditor(BuildContext context) async {
    final result = await showModalBottomSheet<_CoachWorkFormatEditorResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CoachWorkFormatEditorSheet(
        initialWorkFormat: _workFormat == _defaultWorkFormat ? '' : _workFormat,
        initialWorkMode: _workMode == _defaultWorkMode ? '' : _workMode,
        initialAvailability: _availability == _defaultAvailability
            ? ''
            : _availability,
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _workFormat = _displayValue(result.workFormat, _defaultWorkFormat);
      _workMode = _displayValue(result.workMode, _defaultWorkMode);
      _availability = _displayValue(result.availability, _defaultAvailability);
    });

    await _persistCoachCustomization();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Формат работы обновлён')));
    }
  }

  Future<void> _openOrganizationEditor(BuildContext context) async {
    if (_isLoadingOrganizations) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка организаций...')));
      return;
    }

    final selection =
        await showModalBottomSheet<_CoachOrganizationSelectionResult>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => _CoachOrganizationPickerSheet(
            organizations: _organizations,
            selectedOrganization: _selectedOrganization,
            currentAccountId: widget.account.id,
          ),
        );

    if (selection == null) {
      return;
    }

    if (selection.wantsToAdd) {
      final addedOrganization =
          await showModalBottomSheet<_CoachOrganizationFormResult>(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => const _CoachAddOrganizationSheet(),
          );

      if (addedOrganization == null) {
        return;
      }

      final draft = CoachOrganizationModel(
        id: '',
        name: _displayValue(
          addedOrganization.name,
          'Новая организация тренера',
        ),
        sport: addedOrganization.sport,
        address: _displayValue(
          addedOrganization.address,
          _defaultOrganizationAddress,
        ),
        description: _displayValue(
          addedOrganization.description,
          _defaultOrganizationDescription,
        ),
        isCustom: true,
        createdBy: widget.account.id,
        latitude: addedOrganization.latitude,
        longitude: addedOrganization.longitude,
      );

      final saved = await _organizationsRepo.add(draft);
      if (!mounted) return;

      final organization = _CoachOrganization.fromModel(saved);
      setState(() {
        _organizations.insert(0, organization);
        _selectedOrganization = organization;
      });

      await _persistCoachCustomization();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Организация добавлена в профиль')),
        );
      }
      return;
    }

    final organization = selection.organization;
    if (organization == null) {
      return;
    }

    setState(() {
      _selectedOrganization = organization;
    });

    await _persistCoachCustomization();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Организация выбрана')));
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
        contactPhone: _contactPhone.trim(),
        organizationId: _selectedOrganization?.id,
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

  _CoachOrganization? _organizationFromCustomization(
    CoachProfileCustomization customization,
  ) {
    final rawName = customization.organizationName?.trim();
    if (rawName == null || rawName.isEmpty || rawName.toLowerCase() == 'null') {
      return null;
    }

    final draft = _CoachOrganization(
      name: rawName,
      sport: _displayValue(
        customization.organizationSport,
        _defaultOrganizationSport,
      ),
      address: _displayValue(
        customization.organizationAddress,
        _defaultOrganizationAddress,
      ),
      description: _displayValue(
        customization.organizationDescription,
        _defaultOrganizationDescription,
      ),
      isCustom: true,
    );

    return _findOrganization(draft) ?? draft;
  }

  _CoachOrganization? _findOrganization(_CoachOrganization organization) {
    for (final item in _organizations) {
      if (item.comparisonKey == organization.comparisonKey) {
        return item;
      }
    }

    return null;
  }
}

