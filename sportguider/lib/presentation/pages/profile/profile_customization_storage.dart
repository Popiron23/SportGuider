import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportguider/database_service.dart';

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
  final String? specialization;
  final String? sportsAccents;
  final String? achievements;
  final String? workFormat;
  final String? workMode;
  final String? availability;
  final String? contactPhone;
  final String? organizationId;
  final String? organizationName;
  final String? organizationSport;
  final String? organizationAddress;
  final String? organizationDescription;

  const CoachProfileCustomization({
    this.displayName,
    this.headline,
    this.description,
    this.avatarIndex,
    this.specialization,
    this.sportsAccents,
    this.achievements,
    this.workFormat,
    this.workMode,
    this.availability,
    this.contactPhone,
    this.organizationId,
    this.organizationName,
    this.organizationSport,
    this.organizationAddress,
    this.organizationDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'headline': headline,
      'description': description,
      'avatarIndex': avatarIndex,
      'specialization': specialization,
      'sportsAccents': sportsAccents,
      'achievements': achievements,
      'workFormat': workFormat,
      'workMode': workMode,
      'availability': availability,
      'contactPhone': contactPhone,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'organizationSport': organizationSport,
      'organizationAddress': organizationAddress,
      'organizationDescription': organizationDescription,
    };
  }

  factory CoachProfileCustomization.fromJson(Map<String, dynamic> json) {
    return CoachProfileCustomization(
      displayName: json['displayName'] as String?,
      headline: json['headline'] as String?,
      description: json['description'] as String?,
      avatarIndex: json['avatarIndex'] as int?,
      specialization: json['specialization'] as String?,
      sportsAccents: json['sportsAccents'] as String?,
      achievements: json['achievements'] as String?,
      workFormat: json['workFormat'] as String?,
      workMode: json['workMode'] as String?,
      availability: json['availability'] as String?,
      contactPhone: json['contactPhone'] as String?,
      organizationId: json['organizationId'] as String?,
      organizationName: json['organizationName'] as String?,
      organizationSport: json['organizationSport'] as String?,
      organizationAddress: json['organizationAddress'] as String?,
      organizationDescription: json['organizationDescription'] as String?,
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
    final snapshot = await DatabaseService().read(path: 'Users/$accountId');
    if (snapshot != null && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return UserProfileCustomization.fromJson(data);
    }

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
    final data = Map<String, dynamic>.from(customization.toJson())
      ..removeWhere((_, v) => v == null);

    await Future.wait([
      SharedPreferences.getInstance().then(
        (p) => p.setString(_userProfileKey(accountId), jsonEncode(customization.toJson())),
      ),
      if (data.isNotEmpty)
        DatabaseService().update(path: 'Users/$accountId', data: data),
    ]);
  }

  static Future<CoachProfileCustomization> readCoachCustomization(
    String accountId,
  ) async {
    final snapshot = await DatabaseService().read(path: 'Coaches/$accountId');
    if (snapshot != null && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return CoachProfileCustomization.fromJson(data);
    }

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
    final data = Map<String, dynamic>.from(customization.toJson())
      ..removeWhere((_, v) => v == null);

    await Future.wait([
      SharedPreferences.getInstance().then(
        (p) => p.setString(_coachProfileKey(accountId), jsonEncode(customization.toJson())),
      ),
      if (data.isNotEmpty)
        DatabaseService().update(path: 'Coaches/$accountId', data: data),
    ]);
  }

  static Future<List<String>> readUserCoaches(String accountId) async {
    final snapshot = await DatabaseService().read(path: 'Users/$accountId');
    if (snapshot != null && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final raw = data['coaches'];
      if (raw is List) {
        return raw.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      }
    }
    return [];
  }

  static Future<void> saveUserCoaches(
    String accountId,
    List<String> coachIds,
  ) async {
    await DatabaseService().update(
      path: 'Users/$accountId',
      data: {'coaches': coachIds},
    );
  }

  static Future<List<String>> readCoachAthletes(String coachId) async {
    final snapshot = await DatabaseService().read(
      path: 'CoachAthletes/$coachId',
    );
    if (snapshot != null && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.keys.where((k) => k.isNotEmpty).toList();
    }
    return [];
  }
}
