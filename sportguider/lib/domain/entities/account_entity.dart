import 'package:sportguider/core/enums/role.dart';

class AccountEntity {
  final int id;
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
}
