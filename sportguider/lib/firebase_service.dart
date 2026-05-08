import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportguider/core/utils/AuthResult/auth_result.dart';

class FirebaseService {
  static final FirebaseService _singleton = FirebaseService._internal();

  factory FirebaseService() {
    return _singleton;
  }

  FirebaseService._internal();

  static final auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  static OnListenUser(void Function(User?)? doListen) {
    auth.authStateChanges().listen(doListen);
  }

  //Firebase авторизация аккаунта
  static Future<AuthResult?> onLogin({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = AuthResult.normalizeEmail(email);

      final emailError = AuthResult.validateEmail(normalizedEmail);
      if (emailError != null) {
        return AuthResult.error(emailError);
      }

      final passwordError = AuthResult.validatePasswordForLogin(password);
      if (passwordError != null) {
        return AuthResult.error(passwordError);
      }

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      return AuthResult.succes(credential);
    } on FirebaseAuthException catch (e) {
      return AuthResult.fromException(e);
    }
  }

  //Firebase регистрация аккаунта
  static Future<AuthResult?> onRegister({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = AuthResult.normalizeEmail(email);

      final emailError = AuthResult.validateEmail(normalizedEmail);
      if (emailError != null) {
        return AuthResult.error(emailError);
      }

      final passwordError = AuthResult.validatePassword(password);
      if (passwordError != null) {
        return AuthResult.error(passwordError);
      }

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      return AuthResult.succes(credential);
    } on FirebaseAuthException catch (e) {
      return AuthResult.fromException(e);
    }
  }

  logOut() async {
    await auth.signOut();
  }

  onVerifyEmail() async {
    await currentUser?.sendEmailVerification();
  }
}
