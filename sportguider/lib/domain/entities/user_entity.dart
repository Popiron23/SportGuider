enum gender { male, female }

class UserEntity {
  final String? name;
  final int id;
  final int? age;
  final gender? gen;
  final String? email;
  final String? photo;
  final bool? isActive;
  final DateTime? createdAt;

  UserEntity({
    required this.id,
    this.name,
    this.age,
    this.gen,
    this.email,
    this.photo,
    this.isActive = true,
    this.createdAt,
  });
}
