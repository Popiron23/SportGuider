import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/data/models/account_model.dart';

class AccountEntity {
  final String id;
  final String? name;
  final int? age;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final Role? role; // например: user, coach
  final String? favoriteSport;
  final bool? isActive;
  final DateTime? createdAt;

  const AccountEntity({
    required this.id,
    this.name,
    this.age,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.role = Role.user,
    this.favoriteSport,
    this.isActive = true,
    this.createdAt,
  });

  AccountEntity.fromModel(AccountModel model)
    : this(
        id: model.id,
        name: model.name,
        email: model.email,
        phoneNumber: model.phoneNumber,
        role: model.role,
        favoriteSport: model.favoriteSport,
      );
}
