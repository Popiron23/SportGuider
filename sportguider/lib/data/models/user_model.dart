import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Equatable {
  final String? name;
  final String id;
  final int? age;
  final String? email;
  final String? photo;
  final bool? isActive;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    this.name,
    this.age,
    this.email,
    this.photo,
    this.isActive = true,
    this.createdAt,
  });

  // Пустой пользователь (для начального состояния)
  static const empty = UserModel(id: '');

  // Проверка, является ли пользователь авторизованным
  bool get isNotEmpty => this != UserModel.empty;

  // Проверка, является ли пользователь пустым (неавторизованным)
  bool get isEmpty => this == UserModel.empty;

  // Метод для Equatable - определяет, какие поля сравнивать
  @override
  List<Object?> get props => [id, email, name];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as String,
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

  // Создание User из FirebaseUser
  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'null',
      email: firebaseUser.email,
    );
  }
}
