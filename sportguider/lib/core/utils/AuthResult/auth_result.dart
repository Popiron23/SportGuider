import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final UserCredential? credential;
  final String? errorMes;
  late final bool isSuccess;

  AuthResult.succes(this.credential) : errorMes = null {
    isSuccess = true;
  }

  AuthResult.error(this.errorMes) : credential = null {
    isSuccess = false;
  }

  factory AuthResult.fromException(FirebaseAuthException e) {
    String? message;

    switch (e.code) {
      case 'weak-password':
        message = 'Пароль слишком слабый. Используйте минимум 6 символов';
        break;
      case 'email-already-in-use':
        message = 'Этот email уже зарегистрирован';
        break;
      case 'invalid-email':
        message = 'Неверный формат email';
        break;
      case 'operation-not-allowed':
        message = 'Регистрация по email отключена';
        break;
      case 'network-request-failed':
        message = 'Проблема с сетью. Проверьте подключение';
        break;
      default:
        message = 'Ошибка регистрации: ${e.message}';
    }

    return AuthResult.error(message);
  }
}
