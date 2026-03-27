import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportguider/core/enums/role.dart';

class AccountModel extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final Role? role;
  final String? favoriteSport;
  final List<String> coaches;

  const AccountModel({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.role = Role.user,
    this.favoriteSport,
    this.coaches = const [],
  });

  static const empty = AccountModel(id: '');

  @override
  List<Object?> get props => [id, email];
  factory AccountModel.fromFirebaseUser(User? firebaseUser) {
    return AccountModel(
      id: firebaseUser!.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      role: firebaseUser.isAnonymous
          ? Role.user
          : firebaseUser.email == 'admin@admin.com'
          ? Role.admin
          : Role.user,
      favoriteSport: null,
      coaches: [''],
    );
  }
}
