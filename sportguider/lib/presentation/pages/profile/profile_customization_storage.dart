import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserProfileCustomization {
  final String? displayName;
  final String? shortDescription;
  final int? avatarIndex;
  final String? contactEmail;
  final String? contactPhone;
  final String? preferredContactMethod;
  final String? favoriteSport;
  final String? trainingGoal;
  final String? currentFocus;

  const UserProfileCustomization({
    this.displayName,
    this.shortDescription,
    this.avatarIndex,
    this.contactEmail,
    this.contactPhone,
    this.preferredContactMethod,
    this.favoriteSport,
    this.trainingGoal,
    this.currentFocus,
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'shortDescription': shortDescription,
      'avatarIndex': avatarIndex,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'preferredContactMethod': preferredContactMethod,
      'favoriteSport': favoriteSport,
      'trainingGoal': trainingGoal,
      'currentFocus': currentFocus,
    };
  }

  factory UserProfileCustomization.fromJson(Map<String, dynamic> json) {
    return UserProfileCustomization(
      displayName: json['displayName'] as String?,
      shortDescription: json['shortDescription'] as String?,
      avatarIndex: json['avatarIndex'] as int?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      preferredContactMethod: json['preferredContactMethod'] as String?,
      favoriteSport: json['favoriteSport'] as String?,
      trainingGoal: json['trainingGoal'] as String?,
      currentFocus: json['currentFocus'] as String?,
    );
  }
}

class CoachProfileCustomization {
  final String? displayName;
  final String? headline;
  final String? description;
  final int? avatarIndex;

  const CoachProfileCustomization({
    this.displayName,
    this.headline,
    this.description,
    this.avatarIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'headline': headline,
      'description': description,
      'avatarIndex': avatarIndex,
    };
  }

  factory CoachProfileCustomization.fromJson(Map<String, dynamic> json) {
    return CoachProfileCustomization(
      displayName: json['displayName'] as String?,
      headline: json['headline'] as String?,
      description: json['description'] as String?,
      avatarIndex: json['avatarIndex'] as int?,
    );
  }
}

class ProfileCustomizationStorage {
  static String _userProfileKey(String accountId) =>
      'user_profile_customization_$accountId';
  static String _coachProfileKey(String accountId) =>
      'coach_profile_customization_$accountId';

  static Future<UserProfileCustomization> readUserCustomization(
    String accountId,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final rawJson = preferences.getString(_userProfileKey(accountId));

    if (rawJson == null || rawJson.isEmpty) {
      return const UserProfileCustomization();
    }

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return const UserProfileCustomization();
      }

      return UserProfileCustomization.fromJson(decoded);
    } catch (_) {
      return const UserProfileCustomization();
    }
  }

  static Future<void> saveUserCustomization({
    required String accountId,
    required UserProfileCustomization customization,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _userProfileKey(accountId),
      jsonEncode(customization.toJson()),
    );
  }

  static Future<CoachProfileCustomization> readCoachCustomization(
    String accountId,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final rawJson = preferences.getString(_coachProfileKey(accountId));

    if (rawJson == null || rawJson.isEmpty) {
      return const CoachProfileCustomization();
    }

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return const CoachProfileCustomization();
      }

      return CoachProfileCustomization.fromJson(decoded);
    } catch (_) {
      return const CoachProfileCustomization();
    }
  }

  static Future<void> saveCoachCustomization({
    required String accountId,
    required CoachProfileCustomization customization,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _coachProfileKey(accountId),
      jsonEncode(customization.toJson()),
    );
  }
}
