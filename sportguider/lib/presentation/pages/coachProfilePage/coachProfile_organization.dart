part of 'coachProfile_page.dart';

class _CoachOrganizationPickerSheet extends StatelessWidget {
  final List<_CoachOrganization> organizations;
  final _CoachOrganization? selectedOrganization;
  final String currentAccountId;

  const _CoachOrganizationPickerSheet({
    required this.organizations,
    required this.selectedOrganization,
    required this.currentAccountId,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.84,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
                  'Организация',
                  style: GoogleFonts.philosopher(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Выберите готовую точку на карте, к которой привязан тренер, или добавьте свою организацию в анкету.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: organizations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final organization = organizations[index];
                      final isSelected =
                          selectedOrganization?.comparisonKey ==
                          organization.comparisonKey;

                      return _CoachOrganizationOptionTile(
                        organization: organization,
                        isSelected: isSelected,
                        currentAccountId: currentAccountId,
                        onTap: () {
                          Navigator.of(context).pop(
                            _CoachOrganizationSelectionResult(
                              organization: organization,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(
                        const _CoachOrganizationSelectionResult(
                          wantsToAdd: true,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.activeColor,
                      side: BorderSide(color: AppColors.activeColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: Text(
                      'Добавить свою точку',
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
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

class _CoachAddOrganizationSheet extends StatefulWidget {
  const _CoachAddOrganizationSheet();

  @override
  State<_CoachAddOrganizationSheet> createState() =>
      _CoachAddOrganizationSheetState();
}

class _CoachAddOrganizationSheetState
    extends State<_CoachAddOrganizationSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _latController;
  late final TextEditingController _lonController;
  Sport _selectedSport = Sport.football;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _descriptionController = TextEditingController();
    _latController = TextEditingController();
    _lonController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CoachEditorSheet(
      title: 'Новая организация',
      subtitle:
          'Заполните анкету для новой точки на карте: название, вид спорта, адрес, координаты и описание.',
      saveLabel: 'Сохранить организацию',
      onSave: () async {
        final geocoder = YandexGeocoder(
          apiKey: 'a3310aa7-7123-4f79-b44b-33cda9b41cfd',
        );
        final request = DirectGeocodeRequest(
          addressGeocode: _addressController.text,
          lang: Lang.ru,
          results: 1,
        );

        final response = await geocoder.getGeocode(request);

        final lat = response.firstPoint!.lat;
        final lon = response.firstPoint!.lon;
        Navigator.of(context).pop(
          _CoachOrganizationFormResult(
            name: _nameController.text,
            sport: _selectedSport,
            address: _addressController.text,
            description: _descriptionController.text,
            latitude: lat,
            longitude: lon,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CoachEditorLabel(title: 'Название'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _nameController,
            hintText: 'Например, Sports Hub Sokolniki',
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Вид спорта'),
          const SizedBox(height: 10),
          _CoachSportDropdown(
            value: _selectedSport,
            onChanged: (sport) {
              setState(() => _selectedSport = sport);
            },
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Адрес'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _addressController,
            hintText: 'Укажите город, улицу и ориентир',
            minLines: 2,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          const _CoachEditorLabel(title: 'Описание'),
          const SizedBox(height: 10),
          _CoachEditorField(
            controller: _descriptionController,
            hintText:
                'Коротко опишите площадку, формат занятий и чем она удобна ученику.',
            minLines: 3,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _CoachSportDropdown extends StatelessWidget {
  final Sport value;
  final ValueChanged<Sport> onChanged;

  const _CoachSportDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Sport>(
          value: value,
          isExpanded: true,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryColor,
          ),
          items: Sport.values
              .map((s) => DropdownMenuItem(value: s, child: Text(s.ru)))
              .toList(),
          onChanged: (s) {
            if (s != null) onChanged(s);
          },
        ),
      ),
    );
  }
}

class _CoachOrganizationDetails extends StatelessWidget {
  final _CoachOrganization organization;
  final Color accentColor;
  final String currentAccountId;

  const _CoachOrganizationDetails({
    required this.organization,
    required this.accentColor,
    this.currentAccountId = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF2F8FF), Color(0xFFEFFBF9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.location_city_rounded, color: accentColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.name,
                      style: GoogleFonts.philosopher(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ProfileTag(
                          text: organization.sport,
                          color: accentColor,
                        ),
                        if (organization.isCustom && organization.createdBy == currentAccountId)
                          const ProfileTag(
                            text: 'Своя точка',
                            color: Color(0xFF2F71F7),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ProfileInfoRow(
          icon: Icons.place_outlined,
          label: 'Адрес',
          value: organization.address,
        ),
        const SizedBox(height: 18),
        ProfileInfoRow(
          icon: Icons.info_outline_rounded,
          label: 'Описание',
          value: organization.description,
        ),
      ],
    );
  }
}

class _CoachOrganizationEmptyState extends StatelessWidget {
  final VoidCallback onSelect;
  final bool isOwner;

  const _CoachOrganizationEmptyState({
    required this.onSelect,
    this.isOwner = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F71F7).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.add_location_alt_outlined,
                  color: Color(0xFF2F71F7),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Организация пока не выбрана',
                style: GoogleFonts.philosopher(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Здесь появится точка на карте, к которой прикреплён тренер. Можно выбрать готовую организацию или оформить свою.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: AppColors.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        if (isOwner) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSelect,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.activeColor,
                side: BorderSide(color: AppColors.activeColor),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.apartment_rounded),
              label: Text(
                'Выбрать организацию',
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CoachOrganizationOptionTile extends StatelessWidget {
  final _CoachOrganization organization;
  final bool isSelected;
  final String currentAccountId;
  final VoidCallback onTap;

  const _CoachOrganizationOptionTile({
    required this.organization,
    required this.isSelected,
    this.currentAccountId = '',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isSelected
        ? AppColors.activeColor
        : const Color(0xFF1D9A9D);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.activeColor.withValues(alpha: 0.06)
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.activeColor : AppColors.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.place_rounded, color: accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organization.name,
                        style: GoogleFonts.philosopher(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ProfileTag(
                            text: organization.sport,
                            color: accentColor,
                          ),
                          if (organization.isCustom && organization.createdBy == currentAccountId)
                            const ProfileTag(
                              text: 'Своя точка',
                              color: Color(0xFF2F71F7),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.chevron_right_rounded,
                  color: accentColor,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              organization.address,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              organization.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
