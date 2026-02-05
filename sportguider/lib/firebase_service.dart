import 'package:firebase_auth/firebase_auth.dart';

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

  static Future<UserCredential?> onLogin({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return null;
      }
    }
  }

  static Future<UserCredential?> onRegister({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  logOut() async {
    await auth.signOut();
  }

  onVerifyEmail() async {
    await currentUser?.sendEmailVerification();
  }
}
