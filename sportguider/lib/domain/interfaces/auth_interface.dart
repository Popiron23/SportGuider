import 'package:sportguider/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> registerUser(String email, String password);
  Future<void> logOut();
  Stream<AuthEntity?> authStateChanges();
}
