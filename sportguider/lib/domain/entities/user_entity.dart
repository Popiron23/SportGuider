import 'package:sportguider/data/models/account_model.dart';
import 'package:sportguider/domain/entities/account_entity.dart';

enum gender { male, female }

class UserEntity extends AccountEntity {
  final gender? gen;
  final List<String> coaches;

  UserEntity({
    required super.id,
    this.gen,
    this.coaches = const [],
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

  UserEntity.fromModel(AccountModel model)
    : this(
        id: model.id,
        name: model.name,
        email: model.email,
        phoneNumber: model.phoneNumber,
        role: model.role,
        favoriteSport: model.favoriteSport,
      );
}
