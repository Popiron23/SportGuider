import 'package:sportguider/core/enums/sport.dart';

class CoachOrganizationModel {
  final String id;
  final String name;
  final Sport sport;
  final String address;
  final String description;
  final bool isCustom;
  final String createdBy;
  final double latitude;
  final double longitude;

  const CoachOrganizationModel({
    required this.id,
    required this.name,
    required this.sport,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.isCustom = false,
    this.createdBy = '',
  });

  factory CoachOrganizationModel.fromJson(Map<Object?, Object?> json) {
    final rawId = json['id'];
    final id = rawId is int
        ? rawId.toString()
        : ((rawId as String?) ?? json.hashCode.toString());

    final sportStr = json['sport'] as String?;
    Sport sport;
    try {
      sport = Sport.values.firstWhere((e) => e.name == sportStr);
    } catch (_) {
      sport = Sport.values.first;
    }

    return CoachOrganizationModel(
      id: id,
      name: (json['name'] as String?) ?? (json['title'] as String?) ?? '',
      sport: sport,
      address: (json['address'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      isCustom: (json['isCustom'] as bool?) ?? false,
      createdBy: (json['createdBy'] as String?) ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport.name,
      'address': address,
      'description': description,
      'isCustom': isCustom,
      'createdBy': createdBy,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
