part of 'userProfile_page.dart';

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
