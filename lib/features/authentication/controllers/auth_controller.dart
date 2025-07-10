import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController();
});

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> loginWithUserCode(String userCode, String password) async {
    try {
      final querySnapshots = await _firestore
          .collection('users')
          .where('usercode', isEqualTo: userCode)
          .limit(1)
          .get();
      if (querySnapshots.docs.isEmpty) {
        throw FirebaseAuthException(
          code: "user-not-found",
          message: "User not found",
        );
      }

      final userDoc = querySnapshots.docs.first;
      final email = userDoc['email'];

      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result;
    } on FirebaseAuthException catch (e) {
      print("Login error: ${e.message}");
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
