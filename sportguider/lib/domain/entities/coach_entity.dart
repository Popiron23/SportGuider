import 'package:sportguider/data/models/account_model.dart';
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

  CoachEntity.fromModel(AccountModel model)
    : this(
        id: model.id,
        name: model.name,
        email: model.email,
        phoneNumber: model.phoneNumber,
        role: model.role,
        favoriteSport: model.favoriteSport,
      );
}
