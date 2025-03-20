import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
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
      final user = userCredential.user;
      if (user != null) {
        print("Login successful: ${user.email}");
        return user;
      } else {
        print("Login failed: User is null");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth error: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error during email-password login: $e");
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
      print("Signup successful: ${userCredential.user}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth error: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error during email-password signup: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google sign-in aborted by user.");
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      print("Google login successful: ${userCredential.user}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth error during Google sign-in: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error during Google sign-in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      print("User signed out successfully.");
      notifyListeners();
    } catch (e) {
      print("Sign-out error: $e");
    }
  }
}
