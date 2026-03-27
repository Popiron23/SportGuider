import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/data/models/account_model.dart';

class AccountEntity {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final Role? role; // например: user, coach
  final String? favoriteSport;
  final List<String> coaches;

  const AccountEntity({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.role = Role.user,
    this.favoriteSport,
    this.coaches = const [],
  });

  AccountEntity.fromModel(AccountModel model)
    : this(
        id: model.id,
        name: model.name,
        email: model.email,
        phoneNumber: model.phoneNumber,
        role: model.role,
        favoriteSport: model.favoriteSport,
        coaches: model.coaches,
      );

  AccountEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    Role? role,
    String? favoriteSport,
    List<String>? coaches,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      favoriteSport: favoriteSport ?? this.favoriteSport,
      coaches: coaches ?? this.coaches,
    );
  }
}
