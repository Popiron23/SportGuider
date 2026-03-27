part of 'coachProfile_page.dart';

class _CoachShowcaseEditorSheet extends StatefulWidget {
  final List<_CoachAvatarOption> avatarOptions;
  final int initialAvatarIndex;
  final String initialDisplayName;
  final String initialHeadline;
  final String initialDescription;
  final String initialContactPhone;

  const _CoachShowcaseEditorSheet({
    required this.avatarOptions,
    required this.initialAvatarIndex,
    required this.initialDisplayName,
    required this.initialHeadline,
    required this.initialDescription,
    required this.initialContactPhone,
  });

  @override
  State<_CoachShowcaseEditorSheet> createState() =>
      _CoachShowcaseEditorSheetState();
}

class _CoachShowcaseEditorSheetState extends State<_CoachShowcaseEditorSheet> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contactPhoneController;
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
    _contactPhoneController = TextEditingController(
      text: widget.initialContactPhone,
    );
    _selectedAvatarIndex = widget.initialAvatarIndex;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _headlineController.dispose();
    _descriptionController.dispose();
    _contactPhoneController.dispose();
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
            contactPhone: _contactPhoneController.text,
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
                  child: Icon(option.icon, size: 32, color: option.iconColor),
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
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Телефон для связи'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _contactPhoneController,
            hintText: 'Например, +7 900 123 45 67',
            keyboardType: TextInputType.phone,
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
