import 'package:sportguider/domain/entities/account_entity.dart';

class CoachEntity extends AccountEntity {
  final String? sport;
  final String? description;

  CoachEntity({
    this.sport,
    this.description,
    required super.id,
    super.name,
    super.email,
    super.phoneNumber,
    super.role,
    super.isActive,
    super.createdAt,
    super.photoUrl,
    super.age,
    super.favoriteSport,
  });
}
