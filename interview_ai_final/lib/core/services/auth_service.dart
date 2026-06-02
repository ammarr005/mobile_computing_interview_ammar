import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'full_name': fullName,
          'email': email,
          'avg_score': 0,
          'total_sessions': 0,
          'streak': 0,
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}