part of 'userProfile_page.dart';

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

class _CoachCardData {
  final String id;
  final String displayName;
  final String specialization;

  const _CoachCardData({
    required this.id,
    required this.displayName,
    required this.specialization,
  });
}
