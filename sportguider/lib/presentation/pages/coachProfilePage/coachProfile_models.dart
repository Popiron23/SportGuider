part of 'coachProfile_page.dart';

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

class _CoachOrganizationSelectionResult {
  final _CoachOrganization? organization;
  final bool wantsToAdd;

  const _CoachOrganizationSelectionResult({
    this.organization,
    this.wantsToAdd = false,
  });
}

class _CoachOrganizationFormResult {
  final String name;
  final Sport sport;
  final String address;
  final String description;
  final double latitude;
  final double longitude;

  const _CoachOrganizationFormResult({
    required this.name,
    required this.sport,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

class _CoachOrganization {
  final String id;
  final String name;
  final String sport;
  final String address;
  final String description;
  final bool isCustom;

  const _CoachOrganization({
    this.id = '',
    required this.name,
    required this.sport,
    required this.address,
    required this.description,
    this.isCustom = false,
  });

  factory _CoachOrganization.fromModel(CoachOrganizationModel model) {
    return _CoachOrganization(
      id: model.id,
      name: model.name,
      sport: model.sport.ru,
      address: model.address,
      description: model.description,
      isCustom: model.isCustom,
    );
  }

  String get comparisonKey =>
      '${name.trim().toLowerCase()}|${address.trim().toLowerCase()}';
}
