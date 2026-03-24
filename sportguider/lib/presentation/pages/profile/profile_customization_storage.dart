import 'package:shared_preferences/shared_preferences.dart';

class UserProfileCustomization {
  final String displayName;
  final String shortDescription;
  final int avatarIndex;

  const UserProfileCustomization({
    required this.displayName,
    required this.shortDescription,
    required this.avatarIndex,
  });
}

class ProfileCustomizationStorage {
  static String _displayNameKey(String accountId) =>
      'user_profile_display_name_$accountId';

  static String _descriptionKey(String accountId) =>
      'user_profile_short_description_$accountId';

  static String _avatarKey(String accountId) => 'user_profile_avatar_$accountId';

  static Future<UserProfileCustomization> readUserCustomization(
    String accountId,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    return UserProfileCustomization(
      displayName: preferences.getString(_displayNameKey(accountId)) ?? '',
      shortDescription:
          preferences.getString(_descriptionKey(accountId)) ?? '',
      avatarIndex: preferences.getInt(_avatarKey(accountId)) ?? 0,
    );
  }

  static Future<void> saveUserCustomization({
    required String accountId,
    required String displayName,
    required String shortDescription,
    required int avatarIndex,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_displayNameKey(accountId), displayName);
    await preferences.setString(_descriptionKey(accountId), shortDescription);
    await preferences.setInt(_avatarKey(accountId), avatarIndex);
  }
}
