class UserModel {
  final String? name;
  final int id;
  final int? age;
  final String? email;
  final String? photo;
  final bool? isActive;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    this.name,
    this.age,
    this.email,
    this.photo,
    this.isActive = true,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as int,
      name: json["name"] as String,
      age: json["age"] as int,
      email: json["email"] as String,
      photo: json["photo"] as String,
      createdAt: DateTime.parse(json["created_at"] as String),
      isActive: json["is_active"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": name,
      "age": age,
      "email": email,
      "photo": photo,
      "created_at": createdAt,
      "is_active": isActive,
    };
  }
}
