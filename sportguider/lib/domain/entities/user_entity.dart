enum gender { male, female }

class UserEntity {
  final String name;
  final int id;
  final int age;
  final gender gen;
  final String email;
  final String? photo;
  final bool isActive;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.gen,
    required this.email,
    this.photo,
    this.isActive = true,
    required this.createdAt,
  });
}
