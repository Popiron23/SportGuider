import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final UserCredential? credential;
  final String? errorMes;
  late final bool isSuccess;

  /// Normalize email for consistent validation and Firebase calls.
  /// - trims whitespace
  /// - lowercases the domain part
  static String normalizeEmail(String rawEmail) {
    final email = rawEmail.trim();
    final parts = email.split('@');
    if (parts.length != 2) return email;
    return '${parts[0]}@${parts[1].toLowerCase()}';
  }

  /// Returns error message if email is invalid, otherwise `null`.
  static String? validateEmail(String rawEmail) {
    final email = normalizeEmail(rawEmail);

    if (email.isEmpty) {
      return 'Введите email';
    }

    // Keep it simple and robust (no whitespace, reasonable length).
    if (email.length > 254) {
      return 'Email слишком длинный';
    }
    if (email.contains(RegExp(r'\s'))) {
      return 'Email не должен содержать пробелы';
    }

    final parts = email.split('@');
    if (parts.length != 2) {
      return 'Неверный формат email';
    }

    final local = parts[0];
    final domain = parts[1];

    if (local.isEmpty || domain.isEmpty) {
      return 'Неверный формат email';
    }

    if (local.length > 64) {
      return 'Неверный формат email';
    }

    // Basic "good enough" email format check.
    final basicRegex = RegExp(
      r"^[A-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Z0-9-]+(?:\.[A-Z0-9-]+)*\.[A-Z]{2,}$",
      caseSensitive: false,
    );

    if (!basicRegex.hasMatch(email)) {
      return 'Неверный формат email';
    }

    // Extra structural checks to catch common typos.
    if (local.startsWith('.') || local.endsWith('.')) {
      return 'Неверный формат email';
    }
    if (local.contains('..') || domain.contains('..')) {
      return 'Неверный формат email';
    }

    final domainLabels = domain.split('.');
    for (final label in domainLabels) {
      if (label.isEmpty || label.length > 63) {
        return 'Неверный формат email';
      }
      if (label.startsWith('-') || label.endsWith('-')) {
        return 'Неверный формат email';
      }
    }

    return null;
  }

  /// Returns error message if password is invalid, otherwise `null`.
  static String? validatePassword(String rawPassword) {
    if (rawPassword.isEmpty) {
      return 'Введите пароль';
    }

    // Do not allow whitespace at all (including leading/trailing spaces).
    if (rawPassword.contains(RegExp(r'\s'))) {
      return 'Пароль не должен содержать пробелы';
    }

    const minLength = 8;
    if (rawPassword.length < minLength) {
      return 'Пароль слишком короткий. Минимум $minLength символов';
    }
    if (rawPassword.length > 72) {
      return 'Пароль слишком длинный';
    }

    final hasLower = RegExp(r'[a-z]').hasMatch(rawPassword);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(rawPassword);
    final hasDigit = RegExp(r'\d').hasMatch(rawPassword);
    final hasSpecial = RegExp(r'[^\w\s]').hasMatch(rawPassword);

    final missing = <String>[];
    if (!hasUpper) missing.add('заглавную букву');
    if (!hasLower) missing.add('строчную букву');
    if (!hasDigit) missing.add('цифру');
    if (!hasSpecial) missing.add('спецсимвол');

    if (missing.isNotEmpty) {
      return 'Пароль должен содержать: ${missing.join(', ')}.';
    }

    return null;
  }

  /// Login should not reject passwords created under older rules.
  /// Returns error message if password is clearly invalid, otherwise `null`.
  static String? validatePasswordForLogin(String rawPassword) {
    if (rawPassword.isEmpty) {
      return 'Введите пароль';
    }
    if (rawPassword.contains(RegExp(r'\s'))) {
      return 'Пароль не должен содержать пробелы';
    }
    if (rawPassword.length > 72) {
      return 'Пароль слишком длинный';
    }
    return null;
  }

  AuthResult.succes(this.credential) : errorMes = null {
    isSuccess = true;
  }

  AuthResult.error(this.errorMes) : credential = null {
    isSuccess = false;
  }

  factory AuthResult.fromLoginException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'invalid-email':
        message = 'Неверный формат email';
        break;
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        message = 'Неверный email или пароль';
        break;
      case 'user-disabled':
        message = 'Этот аккаунт отключён';
        break;
      case 'too-many-requests':
        message = 'Слишком много попыток входа. Попробуйте позже';
        break;
      case 'operation-not-allowed':
        message = 'Вход по email и паролю отключён';
        break;
      case 'network-request-failed':
        message = 'Проблема с сетью. Проверьте подключение';
        break;
      case 'requires-recent-login':
        message = 'Требуется повторный вход в аккаунт';
        break;
      case 'internal-error':
        message = 'Внутренняя ошибка сервера авторизации';
        break;
      default:
        message = 'Не удалось выполнить вход. Проверьте данные и попробуйте снова';
    }

    return AuthResult.error(message);
  }

  factory AuthResult.fromRegisterException(FirebaseAuthException e) {
    String? message;

    switch (e.code) {
      case 'weak-password':
        message = 'Пароль не соответствует требованиям';
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
      case 'too-many-requests':
        message = 'Слишком много попыток. Попробуйте позже';
        break;
      case 'internal-error':
        message = 'Внутренняя ошибка сервера авторизации';
        break;
      default:
        message = 'Не удалось выполнить регистрацию. Попробуйте снова';
    }

    return AuthResult.error(message);
  }

  factory AuthResult.fromException(FirebaseAuthException e) {
    return AuthResult.fromRegisterException(e);
  }
}
