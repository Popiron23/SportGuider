enum Roles { user, trainer }

class SessionEntity {
  final int id;
  final Set<String>? AuthTokens; //токены авторизации
  final DateTime LastUsed; //время последнего активности
  final Roles? role;

  SessionEntity({
    required this.id,
    this.AuthTokens,
    required this.LastUsed,
    this.role,
  });
}
