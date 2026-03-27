import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  const AuthEntity({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
