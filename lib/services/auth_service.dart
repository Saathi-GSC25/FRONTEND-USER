import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      return userCredential.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      return userCredential.user;
    } catch (e) {
      print("Signup error: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      print("Sign-out error: $e");
    }
  }
}
