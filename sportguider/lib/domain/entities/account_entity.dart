enum Roles { user, trainer }

class AccountEntity {
  final int id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final DateTime createdAt; //дата создания
  final bool isActive; // активен ли аккаунт
  final Roles? role; // например: user, trainer

  const AccountEntity({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    required this.createdAt,
    this.isActive = true,
    this.role = Roles.user,
  });
}
